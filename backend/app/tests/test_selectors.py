import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

from app.services.book_selector import select_books
from app.services.drink_selector import select_drink
from app.services.perfume_selector import select_perfume

# --- Book Selector Tests ---

class MockScorer:
    def calculate_score(self, book, user_input):
        return book.get('mock_score', 0)

def test_select_books_sorting_and_filtering():
    books = [
        {'title': 'Best Match', 'mock_score': 50},
        {'title': 'Good Match', 'mock_score': 20},
        {'title': 'Bad Match', 'mock_score': -500}, # Should be filtered out
        {'title': 'Okay Match', 'mock_score': 10}
    ]
    user_input = {}
    scorer = MockScorer()
    
    results = select_books(books, user_input, scorer, top_k=2)
    
    assert len(results) == 2
    assert results[0]['title'] == 'Best Match'
    assert results[1]['title'] == 'Good Match'
    
    # Verify score was attached
    assert results[0]['match_score'] == 50

# --- Drink Selector Tests ---

def test_select_drink_returns_valid_drink():
    # Fantasy genre maps to 'earthy', 'chocolate' flavors
    selected_book = {'main_genre': 'Fantasy'}
    user_input = {'coffee': 'black'}
    
    # We pass an empty list because the function uses the global DRINK_MAP
    result = select_drink([], selected_book, user_input)
    
    assert isinstance(result, dict)
    assert 'drink' in result
    assert 'flavors' in result

# --- Perfume Selector Tests ---

def test_select_perfume_matching():
    perfumes = [
        {'name': 'Santal 33', 'brand': 'Le Labo', 'scent': 'sandalwood, leather, smoke'},
        {'name': 'Floral Perfume', 'brand': 'Test', 'scent': 'rose, jasmine'}
    ]
    
    # Fantasy genre maps to 'woody', 'smoke', 'leather' in mappings.py
    # 'woody' expands to 'sandalwood' in perfume_selector.py
    selected_book = {'main_genre': 'Fantasy'}
    user_input = {} # No scent input
    
    result = select_perfume(perfumes, selected_book, user_input)
    
    # Should match Santal 33 because of 'smoke', 'leather', and 'sandalwood' (via woody)
    assert result['name'] == 'Santal 33'

def test_select_perfume_empty_list():
    result = select_perfume([], {}, {})
    assert result == {}