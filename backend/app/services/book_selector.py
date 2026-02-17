def select_books(books, user_input, scorer, top_k=3):
    """
    Selects the top_k books based on the user input and scorer logic.
    """
    scored_books = []
    
    for book in books:
        # Calculate score
        score = scorer.calculate_score(book, user_input)
        
        # Create a copy of the book to attach the score without mutating original data permanently
        book_with_score = book.copy()
        book_with_score['match_score'] = score
        
        # Filter out books with negative scores (hard penalties like age restriction)
        if score > -100:
            scored_books.append(book_with_score)
    
    # Sort by score descending
    scored_books.sort(key=lambda x: x['match_score'], reverse=True)
    
    # Return top K
    return scored_books[:top_k]