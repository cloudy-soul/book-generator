from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List
import datetime
from app.services.recommendation_engine import RecommendationEngine

app = FastAPI(title="Book Recommendation API", version="1.0.0")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, restrict this
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic model for request body validation
class UserInput(BaseModel):
    scent: str
    zodiac: str
    coffee: str
    age: int = Field(..., gt=12, description="User's age, must be older than 12")
    genres: List[str]

# Initialize the recommendation engine once on startup
engine = RecommendationEngine(
    books_path='config/books.yaml',
    rules_path='config/rules.yaml',
    perfumes_path='config/perfumes.yaml',
    drinks_path='config/drinks.yaml'
)


# Add this endpoint
@app.get("/")
def read_root():
    return {"message": "Welcome to the Backend API"}

@app.get("/health")
async def health_check():
    """Returns the health status and current timestamp of the API."""
    return {"status": "healthy", "timestamp": datetime.datetime.now().isoformat()}

@app.post("/recommend")
async def recommend(user_input: UserInput):
    """Generates book, perfume, and drink recommendations based on user input."""
    recommendations = engine.generate_recommendations(user_input.model_dump())
    return recommendations