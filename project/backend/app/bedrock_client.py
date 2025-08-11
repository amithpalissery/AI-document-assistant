import boto3
import os
import json

def ask_bedrock(question: str):
    client = boto3.client(
        service_name="bedrock-runtime",
        region_name=os.getenv("AWS_REGION", "us-east-1"),
    )
    # Format prompt for Claude
    prompt = f"\n\nHuman: {question}\n\nAssistant:"
    body = {
        "prompt": prompt,
        "max_tokens_to_sample": 256,
        "temperature": 0.5,
        "top_k": 250,
        "top_p": 1,
        "stop_sequences": ["\n\nHuman:"],
    }
    response = client.invoke_model(
        modelId="anthropic.claude-v2",  # or your chosen model
        contentType="application/json",
        accept="application/json",
        body=json.dumps(body),
    )
    result = json.loads(response['body'].read())
    return result['completion']
