# main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from . import routes

app = FastAPI()

origins = [
    "http://3.87.11.154:3000", # Allow requests from your frontend
    "http://3.87.11.154",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(routes.router)
