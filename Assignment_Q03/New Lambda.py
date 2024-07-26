import boto3

def get_ec2_instances():
    ec2_client = boto3.client('ec2')
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
                    instance_details.append({
                    'InstanceId': instance_id,
                    'Port/Port Range': (f"{from_port}--{to_port}"),
                    'Source': ip_range,
                  })
    return(instance_details)

def format_html_table(instance_details):
    table_html = """
    <p>Please see the Instance ID, Port/Port Range, and Source below:</p>
    <table border="1">
        <tr>
            <th>Instance ID</th>
            <th>Port/Port Range</th>
            <th>Source</th>
        </tr>
    """
    for instance in instance_details:
        table_html += f"""
        <tr>
            <td>{instance['InstanceId']}</td>
            <td>{instance['Port/Port Range']}</td>
            <td>{instance['Source']}</td>
        </tr>
        """
    table_html += "</table>"
    return table_html

def send_email(html_content):
    ses = boto3.client('ses')
    response = ses.send_email(
        Source='ireshsysco@gmail.com',
        Destination={
            'ToAddresses': ['ireshsysco@gmail.com']
        },
        Message={
            'Subject': {
                'Data': 'EC2 Security Group Rules'
            },
            'Body': {
                'Html': {
                    'Data': html_content
                }
            }
        }
    )
    return response


def lambda_handler(event, context):
    instances = get_ec2_instances()
    html_table = format_html_table(instances)
    send_email(html_table)