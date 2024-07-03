# Automated Certificate Approval for AWS ACM Email Validations 

This PowerShell script automates approving SSL/TLS certificates by monitoring a specific email inbox, extracting certificate approval links, and submitting the approval form.

## Features

- Connects to Microsoft Graph API to access emails
- Filters unread emails with subjects containing "certificate request"
- Extracts certificate approval URLs from email bodies
- Submits certificate approval forms automatically
- Marks processed emails as read

## Prerequisites

- PowerShell 5.1 or later
- Microsoft Graph PowerShell SDK
- Access to a Microsoft 365 account with necessary permissions

## Setup

1. Install the Microsoft Graph PowerShell SDK:
   ```PowerShell
   Install-Module Microsoft.Graph -Scope CurrentUser
2. The script will prompt you to log in to your Microsoft account if not authenticated.Or you can use api key for the authentication
3. It will then process any unread emails matching the criteria and attempt to approve the certificates.

## Configuration

- `$userId`: The email address of the account to monitor
- `$scopes`: The Microsoft Graph API scopes required (default is "Mail.ReadWrite")

## How It Works

1. Connects to Microsoft Graph API
2. Retrieves unread emails with subjects containing "certificate request"
3. Extracts the certificate approval URL from each email
4. Submits the approval form with the extracted data
5. Marks the email as read if the approval is successful

## Error Handling

The script includes basic error handling and will output any errors encountered during the process.

## Contributing

Contributions to improve the script are welcome. Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)

