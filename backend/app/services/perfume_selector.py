from app.core.mappings import GENRE_MAP
import random

# Expansion map to bridge Genre Scents (keys) to Perfume Notes (values from perfumes.yaml)
SCENT_EXPANSION = {
    "spicy": ["spice", "spices", "cardamom", "saffron", "pepper", "clove", "cinnamon"],
    "woody": ["wood", "sandalwood", "cedar", "oud", "pine", "cypress", "vetiver", "patchouli", "oakmoss"],
    "floral": ["rose", "jasmine", "lily", "violet", "neroli", "orange blossom", "lavender", "tuberose", "floral"],
    "fresh": ["clean", "citrus", "bergamot", "green", "herbal", "mint", "water", "air"],
    "smokey": ["smoke", "incense", "tobacco", "birch", "ash", "burnt"],
    "fruity": ["fruit", "berry", "berries", "mango", "peach", "fig", "coconut"],
    "earthy": ["earth", "vetiver", "patchouli", "oakmoss", "resins", "truffle", "mineral"],
    "sweet": ["vanilla", "honey", "praline", "chocolate", "caramel", "tonka", "sugar", "marshmallow"],
    "boozy": ["rum", "cognac", "whiskey", "bourbon", "alcohol"],
    "tea-like": ["tea", "matcha", "black tea"],
    "metallic": ["metal", "ink", "steel"],
    "leather": ["leather", "suede"],
    "creamy": ["milk", "lactonic", "sandalwood", "vanilla", "coconut", "cream"],
    "aromatic": ["lavender", "sage", "rosemary", "herbal", "aromatic"],
    "citrus": ["bergamot", "orange", "lemon", "lime", "grapefruit", "neroli"],
    "oceanic": ["sea", "salt", "water", "marine"],
    "clean": ["clean", "soap", "linen", "musk", "aldehyde"],
    "warm": ["amber", "musk", "cinnamon", "vanilla"],
    "nutty": ["almond", "hazelnut", "chestnut", "praline"],
    "powdery": ["iris", "violet", "musk", "powder"],
    "resinous": ["amber", "resins", "frankincense", "myrrh", "benzoin"],
    "honeyed": ["honey", "beeswax"]
}

def select_perfume(perfumes_list, selected_book, user_input):
    """
    Selects a perfume that aligns with the selected book's genre scents
    and the user's scent preference.
    """
    if not perfumes_list:
        return {}

    # 1. Determine target scents (High Level)
    target_scents_high_level = []
    
    # A. Scents associated with the Book's Genre
    if selected_book:
        genre = selected_book.get('main_genre', '').lower()
        target_scents_high_level.extend(GENRE_MAP.get(genre, {}).get('scents', []))

    # 2. Expand High Level Scents to Specific Notes
    expanded_targets = set()
    for scent in target_scents_high_level:
        scent = scent.lower().strip()
        expanded_targets.add(scent) # Add the term itself
        # Add synonyms from map
        if scent in SCENT_EXPANSION:
            expanded_targets.update(SCENT_EXPANSION[scent])

    # 3. Score Perfumes
    scored_perfumes = []
    
    for perfume in perfumes_list:
        score = 0
        # Use 'scent' field from YAML
        perfume_notes_str = str(perfume.get('scent', '')).lower()
        
        for target in expanded_targets:
            if target in perfume_notes_str:
                score += 1
        
        scored_perfumes.append((score, perfume))
    
    # 4. Sort and Pick
    scored_perfumes.sort(key=lambda x: x[0], reverse=True)
    
    if scored_perfumes:
        return scored_perfumes[0][1]
    return random.choice(perfumes_list)