from typing import List, Dict
import difflib

def _normalize_user_genres(user_input: Dict, books: List[Dict]):
    user_genres = [g.lower() for g in user_input.get('genres', []) if isinstance(g, str)]

    available_main_genres = { (book.get('main_genre') or '').lower(): (book.get('main_genre') or '') for book in books }

    genre_aliases = {
        'horror': 'thriller',
        'sci-fi': 'science fiction',
        'scifi': 'science fiction',
        'science fiction': 'science fiction',
        'ya': 'young adult',
        'young adult': 'young adult',
        'romance': 'romance',
        'mystery': 'mystery',
        'thriller': 'thriller',
        'historical': 'historical fiction',
        'historical fiction': 'historical fiction',
    }

    canonical_genres = []
    for ug in user_genres:
        if ug in available_main_genres:
            canonical_genres.append(available_main_genres[ug])
            continue

        alias = genre_aliases.get(ug)
        if alias and alias in available_main_genres:
            canonical_genres.append(available_main_genres[alias])
            continue

        candidates = difflib.get_close_matches(ug, list(available_main_genres.keys()), n=1, cutoff=0.6)
        if candidates:
            canonical_genres.append(available_main_genres[candidates[0]])

    if canonical_genres:
        return [g.lower() for g in canonical_genres]
    return user_genres


def select_books(books: List[Dict], user_input: Dict, scorer, rules: Dict, top_k: int = 3) -> List[Dict]:
    """Return top_k books given books list and user_input using the provided scorer.
    This function prefers books whose main_genre or subgenres match the user's genres.
    """
    user_genres = _normalize_user_genres(user_input, books)

    candidates = []
    if user_genres:
        for book in books:
            main = book.get('main_genre')
            subgenres = book.get('subgenres') or []
            main_match = isinstance(main, str) and main.lower() in user_genres
            sub_match = any(isinstance(s, str) and any(ug in s.lower() for ug in user_genres) for s in subgenres)
            if main_match or sub_match:
                candidates.append(book)

    if not candidates:
        candidates = list(books)

    scored = []
    for book in candidates:
        score = scorer.calculate_score(book, user_input)
        scored.append((book, score))

    scored.sort(key=lambda x: x[1], reverse=True)
    top_books = [item[0] for item in scored[:top_k]]
    return top_books
