import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

from app.services.recommendation_engine import RecommendationEngine


def test_perfume_and_drink_match_book_attributes():
    engine = RecommendationEngine(
        books_path='config/books.yaml',
        perfumes_path='config/perfumes.yaml',
        drinks_path='config/drinks.yaml'
    )

    # Request Thriller, which is associated with 'spicy' scents in mappings.py
    user_input = {
        'zodiac': 'gemini',
        'coffee': 'cappuccino',
        'genres': ['Thriller']
    }

    result = engine.generate_recommendations(user_input)

    assert 'perfume' in result and isinstance(result['perfume'], dict)
    assert 'drink' in result and isinstance(result['drink'], dict)

    perfume_scent = (result['perfume'].get('scent') or '').lower()
    drink_tastes = [t.lower() for t in (result['drink'].get('taste') or []) if isinstance(t, str)]

    # Thriller maps to spicy, woody, smokey, bitter, complex.
    # The test previously only checked for 'spice', which caused failures when 'woody' or 'bitter' items were selected.
    valid_keywords = ['spice', 'spices', 'woody', 'smoke', 'smokey', 'bitter', 'complex', 'leather']
    
    assert any(k in perfume_scent for k in valid_keywords) or \
           any(any(k in dt for k in valid_keywords) for dt in drink_tastes), \
        f"Expected perfume/drink to relate to Thriller attributes {valid_keywords} but got perfume.scent={perfume_scent} and drink.tastes={drink_tastes}"

    print(f"✓ Perfume selected: {result['perfume'].get('name')} with scent: {result['perfume'].get('scent')}")
    print(f"✓ Drink selected: {result['drink'].get('drink')} with tastes: {result['drink'].get('taste')}")
