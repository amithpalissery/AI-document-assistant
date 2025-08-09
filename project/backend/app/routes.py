from fastapi import APIRouter, UploadFile
from pydantic import BaseModel
from . import bedrock_client

router = APIRouter()

class QuestionRequest(BaseModel):
    question: str

@router.post("/upload")
async def upload_file(file: UploadFile):
    # Placeholder: save to S3, process file
    content = await file.read()
    return {"filename": file.filename, "size": len(content)}

@router.post("/ask")
async def ask_question(request: QuestionRequest):
    answer = bedrock_client.ask_bedrock(request.question)
    return {"question": request.question, "answer": answer}
