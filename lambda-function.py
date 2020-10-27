# get the bucket and the file key from the s3 event and you send these 2 informations to the queue

# """  Once the function coded, you have to trigger it with the s3 event. In the ‘Designer’ section click on ‘add trigger’, 
choose S3, and indicate the bucket you want your lambda function to be triggered when something is uploaded on it. 
The prefix and suffix are useful to filter which files must trigger the function. 
If you want to trigger only when a csv file is upload in a directory called data, just indicate in suffix .csv and in prefix /data . 
Then click ‘add’ and your trigger is now ready.


import boto3"""

s3 = boto3.resource('s3')
sqs = boto3.client('sqs')
queue_url = 'your_queue_url'
def lambda_handler(s3_event, context):
    # Get the s3 event
    for record in s3_event.get("Records"):
        bucket = record.get("s3").get("bucket").get("name")
        key = record.get("s3").get("object").get("key")
        
        # Send message to SQS queue
        response = sqs.send_message(
            QueueUrl=queue_url,
            DelaySeconds=1,
            MessageAttributes={
                'key': {
                    'DataType': 'String',
                    'StringValue': key
                }
            },
            MessageBody=(bucket)
        )
