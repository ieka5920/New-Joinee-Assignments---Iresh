import boto3

# Initialize the boto3 clients
ec2_client = boto3.client('ec2')
sns_client = boto3.client('sns')

# Get a list of all instances
response = ec2_client.describe_instances()
instances = [instance for reservation in response['Reservations'] for instance in reservation['Instances']]

# Iterate through the instances and get their security group rules
instance_details = []
for instance in instances:
    instance_id = instance['InstanceId']
    security_groups = instance['SecurityGroups']

    for security_group in security_groups:
        group_id = security_group['GroupId']
        group_response = ec2_client.describe_security_groups(GroupIds=[group_id])
        group_details = group_response['SecurityGroups'][0]

        for ip_permission in group_details['IpPermissions']:
            protocol = ip_permission['IpProtocol']
            if protocol == '-1':
                protocol = 'all'
            from_port = ip_permission.get('FromPort', 'all')
            to_port = ip_permission.get('ToPort', 'all')
            ip_ranges = [ip_range['CidrIp'] for ip_range in ip_permission['IpRanges']]
            for ip_range in ip_ranges:
                instance_details.append(f"{instance_id}, {from_port}-{to_port}, {ip_range}")

# Format the details into a single string with a header
details_str = "Please see the Instance ID, Port/Port Range, and Source below:\n\n"
details_str += "\n".join(instance_details)

#  SNS topic ARN
sns_topic_arn = 'arn:aws:sns:us-east-1:905418439034:AssignmentsQ3'

# Publish the message to SNS
response = sns_client.publish(
    TopicArn=sns_topic_arn,
    Subject='EC2 Security Group Rules',
    Message=details_str
)

print(f"Message published to SNS topic with ID: {response['MessageId']}")
