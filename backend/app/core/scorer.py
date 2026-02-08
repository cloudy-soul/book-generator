from app.core.loader import load_yaml_file

class BookScorer:
    def __init__(self, rules_path):
        self.rules = self._load_rules(rules_path)
    
    def _load_rules(self, rules_path):
        """Load rules from the YAML file."""
        return load_yaml_file(rules_path)
    
    def calculate_score(self, book, user_profile):
        """Calculate a compatibility score between a book and a user profile."""
        score = 0
        scoring = self.rules.get('scoring', {})
        penalties = self.rules.get('penalties', {})
        
        # 1. Age Restriction: Heavy penalty if user is too young.
        age_penalty = penalties.get('age_restricted', -1000)
        if 'age_restriction' in book and user_profile.get('age', 99) < book['age_restriction']:
            return age_penalty

        # 2. Genre Matching
        user_genres = user_profile.get('genres', [])
        book_genre = book.get('main_genre')
        book_subgenres = book.get('subgenres', [])
        
        # Exact Match
        if book_genre in user_genres:
            score += scoring.get('genre_exact', 5)
        # Subgenre Match
        elif any(sub in user_genres for sub in book_subgenres):
            score += scoring.get('genre_sub', 3)

        # 3. Scent Matching
        user_scent = user_profile.get('scent')
        book_scent_list = book.get('scent', [])
        # Handle both list (real data) and string (mock data) for scent
        if isinstance(book_scent_list, str):
            book_scent_list = [book_scent_list]

        # Scent Family (using scent_vibe if available, or direct match)
        if book.get('scent_vibe') == user_scent:
            score += scoring.get('scent_family', 4)
        
        # Scent Note (if user scent preference appears in book scent notes)
        if any(user_scent.lower() in s.lower() for s in book_scent_list):
            score += scoring.get('scent_note', 2)

        # 4. Vibe & Coffee Matching
        # Derive user vibe from coffee choice
        user_coffee = user_profile.get('coffee')
        coffee_rules = self.rules.get('coffee', {}).get(user_coffee, {})
        derived_vibe = coffee_rules.get('vibe')
        
        # Check against book tone or vibe
        book_tone = book.get('tone', '') + ' ' + book.get('vibe', '')
        
        if derived_vibe and derived_vibe.lower() in book_tone.lower():
            score += scoring.get('coffee_vibe_boost', 1)
            score += scoring.get('vibe_match', 3)

        # 5. Zodiac Sign Boost
        zodiac_rules = self.rules.get('zodiac', {})
        user_zodiac = user_profile.get('zodiac')
        if user_zodiac in zodiac_rules:
            zodiac_genres = zodiac_rules[user_zodiac].get('genres', [])
            if book_genre in zodiac_genres:
                score += scoring.get('zodiac_genre_boost', 2)

        return score