import json

def lambda_handler(event, context):
    print(json.dumps(event, indent=4))

    message = 'Hello, World!'
    return {
        'statusCode': 200,
        'body': message
    }
