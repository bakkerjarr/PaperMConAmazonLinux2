# Start all EC2 instances in REGION that have a KEY tag set to VALUE
import boto3
import os

def start_ec2_all():
    region=os.environ['REGION']
    key=os.environ['KEY']
    value=os.environ['VALUE']
    client = boto3.client('ec2', region_name=region)
    response = client.describe_instances()

    for resp in response['Reservations']:
        i = resp['Instances'][0]
        if 0==len(i['Tags']):
            print('EC2 Instance {0} is not part of Auto_Start/Stop'.format(i['InstanceId']))
        else:
            for tag in i['Tags']:
                if tag['Key']==key and tag['Value']==value:
                    if i['State']['Name'] == 'running':
                        print('EC2 instance {0} is already running'.format(i['InstanceId']))
                    elif i['State']['Name'] == 'stopped':
                        client.start_instances(InstanceIds=[i['InstanceId']])
                        print('Started EC2 Instance {0}'.format(i['InstanceId']))
                    elif i['State']['Name'] == 'pending':
                        print('EC2 Instance {0} is currently in pending state'.format(i['InstanceId']))
                    elif i['State']['Name'] == 'stopping':
                        print('EC2 Instance {0} is in stopping state. Please wait before starting'.format(i['InstanceId']))
                elif tag['Key']==key and tag['Value']!=value:
                    print('EC2 instance {0} is not tagged to be started'.format(i['InstanceId']))
                elif tag['Key']!=key:
                    print('EC2 instance {0} tag {1} ignored'.format(i['InstanceId'],tag['Key']))
                elif len(tag['Key']) == 0 or len(tag['Value']) == 0:
                    print('EC2 Instance {0} tag {1} ignored'.format(i['InstanceId'],tag['Key']))

def lambda_handler(event, context):
    start_ec2_all()
