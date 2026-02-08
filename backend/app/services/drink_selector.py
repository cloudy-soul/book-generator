from typing import List, Dict

def select_drink(drinks: List[Dict], top_book: Dict, user_input: Dict, rules: Dict) -> Dict:
    """Select a drink based on coffee rule vibes, then top_book taste overlap."""
    selected = drinks[0] if drinks else {}
    user_coffee = user_input.get('coffee')
    coffee_rules = rules.get('coffee', {}).get(user_coffee, {}) if user_coffee else {}

    # 1) coffee-vibe hint
    if coffee_rules:
        vibe = (coffee_rules.get('vibe') or '').lower()
        if vibe:
            for drink in drinks:
                drink_tastes = [dt.lower().strip() for dt in (drink.get('taste') or []) if isinstance(dt, str)]
                if any(vibe in dt or dt in vibe for dt in drink_tastes):
                    return drink

    # 2) top book tastes
    if top_book:
        book_tastes = [t.lower().strip() for t in (top_book.get('taste') or []) if isinstance(t, str)]
        if book_tastes:
            for drink in drinks:
                drink_tastes = [dt.lower().strip() for dt in (drink.get('taste') or []) if isinstance(dt, str)]
                if set(book_tastes) & set(drink_tastes):
                    return drink

    return selected
