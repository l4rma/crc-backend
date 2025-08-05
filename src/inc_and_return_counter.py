import boto3
import json

dynamodb = boto3.resource("dynamodb", region_name="eu-west-1")
table = dynamodb.Table("crc-visitor-counter")

def increment_counter(event, context):
    response = table.update_item(
        Key={"PK": "view-counter"},
        UpdateExpression="ADD #v :incr",
        ExpressionAttributeNames={"#v": "views"},
        ExpressionAttributeValues={":incr": 1},
        ReturnValues="UPDATED_NEW"
    )
    views = int(response["Attributes"]["views"])
    print(f"Updated view count: {views}")
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET"

        },
        "body": json.dumps({"views": views})
    }
