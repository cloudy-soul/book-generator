from app.core.mappings import ZODIAC_GENRES, GENRE_MAP

class BookScorer:
    # Default scoring weights replacing rules.yaml
    SCORING = {
        'genre_exact': 5,
        'genre_sub': 3,
        'zodiac_genre_boost': 2,
        'vibe_match': 3 # Reserved for future coffee-vibe logic
    }

    def __init__(self):
        pass
    
    def calculate_score(self, book, user_profile):
        """Calculate a compatibility score between a book and a user profile."""
        score = 0
        
        # 1. Genre Matching
        user_genres = user_profile.get('genres', [])
        book_genre = book.get('main_genre')
        book_subgenres = book.get('subgenres', [])
        
        # Exact Match
        if book_genre in user_genres:
            score += self.SCORING.get('genre_exact', 5)
        # Subgenre Match
        elif any(sub in user_genres for sub in book_subgenres):
            score += self.SCORING.get('genre_sub', 3)

        # 2. Zodiac Sign Boost
        user_zodiac = user_profile.get('zodiac', '').lower()
        preferred_genres = ZODIAC_GENRES.get(user_zodiac, [])
        
        if book_genre in preferred_genres:
            score += self.SCORING.get('zodiac_genre_boost', 2)

        return score