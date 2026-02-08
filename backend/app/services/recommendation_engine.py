from app.core.loader import load_yaml_file
from app.core.scorer import BookScorer
from app.services.book_selector import select_books
from app.services.perfume_selector import select_perfume
from app.services.drink_selector import select_drink
from app.services.explanation import explain_book_choice


class RecommendationEngine:
    def __init__(self, books_path, rules_path, perfumes_path, drinks_path):
        self.books = load_yaml_file(books_path).get('books', [])
        self.rules = load_yaml_file(rules_path)
        self.perfumes = load_yaml_file(perfumes_path).get('perfumes', [])
        self.drinks = load_yaml_file(drinks_path).get('drinks', [])
        self.scorer = BookScorer(rules_path)

    def generate_recommendations(self, user_input):
        # 1) Select top books using book_selector
        top_books = select_books(self.books, user_input, self.scorer, self.rules, top_k=3)

        # Determine canonical user_genres for explanations (reuse book_selector internal logic by recomputing)
        user_genres = [g.lower() for g in user_input.get('genres', []) if isinstance(g, str)]

        # Attach explanations to each book
        for book in top_books:
            book['reason'] = explain_book_choice(book, user_input, user_genres)

        # 2) Select perfume and drink via dedicated selectors
        selected_perfume = select_perfume(self.perfumes, top_books[0] if top_books else None, user_input, self.rules)
        selected_drink = select_drink(self.drinks, top_books[0] if top_books else None, user_input, self.rules)

        return {
            "books": top_books,
            "perfume": selected_perfume,
            "drink": selected_drink,
            "explanation": "Here are your personalized recommendations based on your unique taste profile."
        }