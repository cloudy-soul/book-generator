import pytest
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

from app.core.scorer import BookScorer

def test_book_scorer_initialization():
    """Test scorer initializes with rules"""
    scorer = BookScorer('config/rules.yaml')
    assert scorer.rules is not None
    assert 'zodiac' in scorer.rules
    print("✓ Scorer initialized correctly")

def test_genre_matching():
    """Test genre matching scoring"""
    scorer = BookScorer('config/rules.yaml')
    
    # Mock user profile and book
    user_profile = {
        'genres': ['fantasy', 'mystery'],
        'vibe': 'cozy',
        'scent': 'woody',
        'age': 25,
        'coffee': 'latte'
    }
    
    test_book = {
        'title': 'Test Book',
        'main_genre': 'fantasy',
        'scent_vibe': 'woody',
        'vibe': 'cozy',
        'tags': ['magic', 'adventure']
    }
    
    score = scorer.calculate_score(test_book, user_profile)
    
    # Genre Exact (5) + Scent Family (4) + Vibe Match (3) + Coffee Boost (1) = 13
    assert score >= 12
    print(f"✓ Genre matching score: {score}")

def test_age_restriction():
    """Test age restriction penalty"""
    scorer = BookScorer('config/rules.yaml')
    
    user_profile = {
        'genres': ['fantasy'],
        'age': 15,  # Underage for adult books
        'vibe': 'any',
        'scent': 'any'
    }
    
    test_book = {
        'title': 'Adult Book',
        'main_genre': 'fantasy',
        'age_restriction': 18,  # Requires 18+
        'scent_vibe': 'any',
        'vibe': 'any'
    }
    
    score = scorer.calculate_score(test_book, user_profile)
    assert score < 0  # Should be negative due to penalty
    print(f"✓ Age restriction applied: {score}")

def test_scoring_consistency():
    """Same input should give same score"""
    scorer = BookScorer('config/rules.yaml')
    
    user_profile = {'genres': ['romance'], 'age': 20, 'vibe': 'cozy', 'scent': 'floral'}
    book = {'title': 'Romance Novel', 'main_genre': 'romance', 'scent_vibe': 'floral', 'vibe': 'cozy'}
    
    score1 = scorer.calculate_score(book, user_profile)
    score2 = scorer.calculate_score(book, user_profile)
    
    assert score1 == score2
    print(f"✓ Consistent scoring: {score1} == {score2}")