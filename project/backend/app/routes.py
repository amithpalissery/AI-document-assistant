from fastapi import APIRouter, UploadFile
from pydantic import BaseModel
from . import bedrock_client
s3 = boto3.client('s3', region_name=os.getenv("AWS_REGION", "us-east-1"))

router = APIRouter()

class QuestionRequest(BaseModel):
    question: str

@router.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    bucket = "your-s3-bucket-name"
    s3.upload_fileobj(file.file, bucket, file.filename)
    return {"filename": file.filename, "status": "uploaded"}

@router.post("/ask")
async def ask_question(request: QuestionRequest):
    answer = bedrock_client.ask_bedrock(request.question)
    return {"question": request.question, "answer": answer}
