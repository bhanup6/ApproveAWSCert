import boto3
import json

def lambda_handler(event, context):
    # Check if instance_id is provided in the event
    if 'instance_id' not in event:
        return {
            'statusCode': 400,
            'body': json.dumps('Error: instance_id parameter is required')
        }
    
    instance_id = event['instance_id']
    ssm_client = boto3.client('ssm')
    
    # Define the parameters for the SSM command
    document_name = "AWS-ConfigureAWSPackage"
    parameters = {
        "action": ["Install"],
        "name": ["WindowsSamplePackage"],
        "installationType": ["In-place update"]
    }
    
    # Specify the target instance using the provided instance_id
    targets = [
        {
            'Key': 'InstanceIds',
            'Values': [instance_id]
        }
    ]
    
    try:
        # Send the command to install the package
        response = ssm_client.send_command(
            DocumentName=document_name,
            Parameters=parameters,
            Targets=targets
        )
        
        command_id = response['Command']['CommandId']
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Command sent successfully',
                'CommandId': command_id,
                'InstanceId': instance_id
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
