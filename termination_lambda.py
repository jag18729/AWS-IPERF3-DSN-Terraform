import boto3
import datetime
from datetime import datetime, timezone

def handler(event, context):
    regions = ['us-west-2', 'us-west-1', 'ap-southeast-2']
    
    for region in regions:
        ec2 = boto3.client('ec2', region_name=region)
        
        instances = ec2.describe_instances(
            Filters=[
                {'Name': 'tag:AutoTerminate', 'Values': ['true']},
                {'Name': 'instance-state-name', 'Values': ['running', 'stopped']}
            ]
        )
        
        for reservation in instances['Reservations']:
            for instance in reservation['Instances']:
                instance_id = instance['InstanceId']
                
                termination_date = None
                for tag in instance['Tags']:
                    if tag['Key'] == 'TerminationDate':
                        termination_date = tag['Value']
                        break
                
                if termination_date:
                    termination_datetime = datetime.strptime(termination_date, '%Y-%m-%dT%H:%M:%SZ')
                    if datetime.now(timezone.utc) > termination_datetime:
                        print(f"Terminating instance {instance_id} in region {region}")
                        ec2.terminate_instances(InstanceIds=[instance_id])

    return {
        'statusCode': 200,
        'body': 'Termination check completed'
    }