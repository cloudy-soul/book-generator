import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

import pytest
from app.core.scorer import BookScorer

@pytest.fixture
def scorer():
    return BookScorer()

def test_zodiac_boost(scorer):
    """Test that users get a boost if the book genre matches their Zodiac sign."""
    # Aries likes Thriller (defined in mappings.py)
    book = {'main_genre': 'Thriller'}
    user_profile = {'age': 25, 'zodiac': 'aries', 'genres': []}
    
    score = scorer.calculate_score(book, user_profile)
    
    # Should receive 'zodiac_genre_boost' (2)
    assert score == 2

def test_combined_score(scorer):
    """Test a scenario with multiple matching factors."""
    book = {'main_genre': 'Romance'}
    user_profile = {'genres': ['Romance']}
    
    score = scorer.calculate_score(book, user_profile)
    
    # 5 (Genre Exact)
    assert score == 5