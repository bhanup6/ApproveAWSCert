Add-Type -AssemblyName System.Web
$urlPattern = "\(( https://[^\)]+)\)"
$userId="samplemailbox.com"
$scopes = @("Mail.ReadWrite")
$params = @{
        isRead = "true"
    }
$connection=Connect-MgGraph -Scopes $scope
if ($connection) {
    Write-Host "Successfully connected to Microsoft Graph with Mail.ReadWrite scope."
$messages = Get-MgUserMessage -UserId $userId   -Filter "IsRead eq false" |where {$_.Subject -match "certificate request* "}|select Subject,Body,From,Id
if($messages -ne $null){
    
    foreach ($message in $messages) {
    
        if ($plainTextBody -match $urlPattern) {

            $url = $matches[1]
            Write-Host "URL:$(($url).Trim())"
            $certurl= $url.Trim()
            $res=Invoke-RestMethod -Uri $certurl -Method Get -UseDefaultCredentials 
            $html =$res
            $formAction = ($html -split 'form action="')[1].Split('"')[0]
            $validationToken = ($html -split 'name="validationToken" value="')[1].Split('"')[0]
            $validationArn = ($html -split 'name="validationArn" value="')[1].Split('"')[0]
            $domainName = ($html -split 'name="domainName" value="')[1].Split('"')[0]
            $accountId = ($html -split 'name="accountId" value="')[1].Split('"')[0]
            $region = ($html -split 'name="region" value="')[1].Split('"')[0]
            $certificateIdentifier = ($html -split 'name="certificateIdentifier" value="')[1].Split('"')[0]
            $formData = @{
                validationToken = $validationToken
                validationArn = $validationArn
                domainName = $domainName
                accountId = $accountId
                region = $region
                certificateIdentifier = $certificateIdentifier
                validationApprovalStatus = "APPROVED"
            }
            $formdata|FT
            try {
                    $response = Invoke-WebRequest -Uri $formAction -Method Post -Body $formData
                     if ($response.StatusCode -eq 200) {
                             Write-Host "Certificate approval successful!"
                             Update-MgUserMessage -UserId $userId -MessageId $message.Id -BodyParameter $params
                             Write-Host "Email marked as read successfully."
                }    else{
                             Write-Host "Certificate approval failed. Status code: $($response.StatusCode)"
                    }
}          catch {
                     Write-Host "An error occurred: $_"
}
    
           }


}
}
else{

    "Found no mails"

}
}
else {
    Write-Host "Failed to connect to Microsoft Graph."
}