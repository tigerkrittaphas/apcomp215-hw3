from fastapi import FastAPI
import os
from starlette.middleware.cors import CORSMiddleware
import math


# Set root_path based on environment
ROOT_PATH = os.getenv("ROOT_PATH", "")

# Setup FastAPI app
api_app = FastAPI(title="API Server", description="API Server", version="v1")

# Routes
@api_app.get("/q1")
async def sum_sqrt(x: float, y: float):

    # check if x and y are numbers
    if not isinstance(x, (int, float)) or not isinstance(y, (int, float)):
        return {"error": "x and y must be numbers"}
    return math.sqrt(x**2 + y**2)

@api_app.post("/q2")
async def text_repeater(data: dict):
    """ 
    this will accept a json dict with key 'text' and 'repeat' 
    Input:
        data: dict with keys 'text' (str), 'repeat' (int), and optional 'delimiter' (str)
    Output: string of text repeated 'repeat' times, with default delimiter as whitespace
    """

    if 'text' not in data or 'repeat' not in data:
        return {"error": "Missing 'text' or 'repeat' in request body"}
    text = data['text']
    repeat = data['repeat']
    delimiter = data.get('delimiter', ' ')
    return delimiter.join([text] * repeat)