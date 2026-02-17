from app.core.mappings import DRINK_MAP, GENRE_MAP
import random

def select_drink(drinks_list, selected_book, user_input):
    """
    Selects a drink from DRINK_MAP that matches the flavor profile 
    of the selected book's genre.
    """
    # 1. Determine target flavors
    target_flavors = []
    
    # A. From Book Genre (Primary driver based on relationships.txt)
    if selected_book:
        genre = selected_book.get('main_genre', '').lower()
        target_flavors.extend(GENRE_MAP.get(genre, {}).get('flavors', []))
        
    # B. From User Coffee Preference (if it maps to a flavor keyword)
    user_coffee = user_input.get('coffee', '').lower()
    target_flavors.append(user_coffee) 

    # 2. Score Drinks
    scored_drinks = []
    
    # Use the provided drinks_list (from YAML) if available, otherwise fallback
    candidates = drinks_list if drinks_list else DRINK_MAP
    
    for drink in candidates:
        score = 0
        # Check both 'taste' (from YAML) and 'flavors' (from mapping) keys for robustness
        drink_flavors = [f.lower() for f in drink.get('taste', []) + drink.get('flavors', [])]
        
        # Calculate overlap
        for target in target_flavors:
            if any(target in df for df in drink_flavors):
                score += 1
        
        scored_drinks.append((score, drink))
    
    # 3. Sort and Pick
    scored_drinks.sort(key=lambda x: x[0], reverse=True)
    
    # Return the best match, or a random one if no matches found
    if scored_drinks:
        return scored_drinks[0][1]
    return random.choice(candidates)