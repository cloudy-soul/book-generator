import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

from app.services.recommendation_engine import RecommendationEngine


def test_perfume_and_drink_match_book_attributes():
    engine = RecommendationEngine(
        books_path='config/books.yaml',
        rules_path='config/rules.yaml',
        perfumes_path='config/perfumes.yaml',
        drinks_path='config/drinks.yaml'
    )

    # Request science fiction so Dune/Project Hail Mary candidates appear
    user_input = {
        'scent': 'spicy',
        'zodiac': 'gemini',
        'coffee': 'cappuccino',
        'age': 40,
        'genres': ['Science Fiction']
    }

    result = engine.generate_recommendations(user_input)

    assert 'perfume' in result and isinstance(result['perfume'], dict)
    assert 'drink' in result and isinstance(result['drink'], dict)

    perfume_scent = (result['perfume'].get('scent') or '').lower()
    drink_tastes = [t.lower() for t in (result['drink'].get('taste') or []) if isinstance(t, str)]

    # Expect the perfume scent to mention 'spice' or similar when top book has 'spice' in its scent
    assert ('spice' in perfume_scent) or ('spices' in perfume_scent) or any('spice' in dt for dt in drink_tastes) , \
        f"Expected perfume/drink to relate to 'spice' but got perfume.scent={perfume_scent} and drink.tastes={drink_tastes}"

    print(f"✓ Perfume selected: {result['perfume'].get('name')} with scent: {result['perfume'].get('scent')}")
    print(f"✓ Drink selected: {result['drink'].get('drink')} with tastes: {result['drink'].get('taste')}")
