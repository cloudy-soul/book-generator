import pytest
from fastapi.testclient import TestClient
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

from app.main import app

client = TestClient(app)

def test_health_endpoint():
    """Test /health endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "timestamp" in data
    print("✓ Health endpoint working")

def test_recommend_endpoint_valid():
    """Test /recommend with valid data"""
    test_payload = {
        "scent": "woody",
        "zodiac": "taurus",
        "coffee": "cappuccino",
        "age": 28,
        "genres": ["mystery", "thriller"]
    }
    
    response = client.post("/recommend", json=test_payload)
    assert response.status_code == 200
    
    data = response.json()
    assert "books" in data
    assert len(data["books"]) == 3
    assert "perfume" in data
    assert "drink" in data
    assert "explanation" in data
    
    print("✓ Recommendation endpoint returns valid structure")

def test_recommend_endpoint_invalid_age():
    """Test /recommend with invalid age"""
    test_payload = {
        "scent": "floral",
        "zodiac": "gemini",
        "coffee": "latte",
        "age": 10,  # Too young
        "genres": ["fantasy"]
    }
    
    response = client.post("/recommend", json=test_payload)
    # Pydantic validation should return 422 for age < 12
    assert response.status_code == 422
    print("✓ Handles edge case age")

def test_recommend_missing_fields():
    """Test /recommend with missing required fields"""
    test_payload = {
        "scent": "fresh",
        # Missing other fields
    }
    
    response = client.post("/recommend", json=test_payload)
    # FastAPI should return 422 for validation error
    assert response.status_code == 422
    print("✓ Proper validation on missing fields")