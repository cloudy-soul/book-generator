import pytest
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

from app.services.recommendation_engine import RecommendationEngine

def test_engine_initialization():
    """Test engine loads all components"""
    engine = RecommendationEngine(
        books_path='config/books.yaml',
        rules_path='config/rules.yaml',
        perfumes_path='config/perfumes.yaml',
        drinks_path='config/drinks.yaml'
    )
    assert engine.books is not None
    assert engine.perfumes is not None
    assert engine.drinks is not None
    print("✓ Engine initialized with all data")

def test_recommendation_flow():
    """Test full recommendation pipeline"""
    engine = RecommendationEngine(
        books_path='config/books.yaml',
        rules_path='config/rules.yaml',
        perfumes_path='config/perfumes.yaml',
        drinks_path='config/drinks.yaml'
    )
    
    # Sample user input
    user_input = {
        'scent': 'fresh',
        'zodiac': 'libra',
        'coffee': 'latte',
        'age': 22,
        'genres': ['romance', 'contemporary']
    }
    
    result = engine.generate_recommendations(user_input)
    
    # Check result structure
    assert 'books' in result
    assert 'perfume' in result
    assert 'drink' in result
    assert 'explanation' in result
    
    # Should recommend exactly 3 books
    assert len(result['books']) == 3
    
    # Check each book has required fields
    for book in result['books']:
        assert 'title' in book
        assert 'author' in book
        assert 'reason' in book  # Explanation for why chosen
    
    print(f"✓ Generated {len(result['books'])} book recommendations")
    print(f"✓ Perfume: {result['perfume'].get('name', 'N/A')}")
    print(f"✓ Drink: {result['drink'].get('name', 'N/A')}")

def test_empty_genres():
    """Test with empty genre list"""
    engine = RecommendationEngine(
        books_path='config/books.yaml',
        rules_path='config/rules.yaml',
        perfumes_path='config/perfumes.yaml',
        drinks_path='config/drinks.yaml'
    )
    
    user_input = {
        'scent': 'citrus',
        'zodiac': 'aries',
        'coffee': 'espresso',
        'age': 30,
        'genres': []  # Empty genres
    }
    
    result = engine.generate_recommendations(user_input)
    # Should still return recommendations based on other factors
    assert len(result['books']) == 3
    print("✓ Handles empty genres gracefully")