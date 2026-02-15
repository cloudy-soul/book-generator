from typing import Dict, List

def explain_book_choice(book: Dict, user_input: Dict, user_genres: List[str]) -> str:
    """Generate a short human-readable reason for why a book was selected."""
    reasons = []
    main_genre = book.get('main_genre')
    if isinstance(main_genre, str) and any(main_genre.lower() == g for g in user_genres):
        reasons.append(f"matches your interest in {main_genre}")

    # scent preference check: book 'scent' is list in config
    book_scents = [s.lower() for s in (book.get('scent') or []) if isinstance(s, str)]
    user_scent = user_input.get('scent')
    if isinstance(user_scent, str) and any(user_scent.lower() in bs for bs in book_scents):
        reasons.append(f"aligns with your {user_scent} scent preference")

    if reasons:
        return f"This book {' and '.join(reasons)}."
    return f"A top-rated {main_genre} selection based on your profile."
