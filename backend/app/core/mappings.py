"""
Mappings derived from relationships.txt to drive recommendation logic.
"""

GENRE_MAP = {
    "romance": {
        "scents": ["floral", "sweet", "clean", "fruity", "creamy", "spicy"],
        "flavors": ["sweet", "spicy", "floral", "cinnamon", "caramel", "vanilla"]
    },
    "fantasy": {
        "scents": ["woody", "smoke", "leather", "oceanic", "earthy", "citrus"],
        "flavors": ["sour", "earthy", "chocolate", "zesty"]
    },
    "science fiction": {  # Mapped from sci-fi
        "scents": ["aromatic", "resinous", "leather", "oceanic", "earthy", "citrus"],
        "flavors": ["bitter", "earthy", "nutty", "smokey", "tangy"]
    },
    "fiction": {
        "scents": ["woody", "fresh", "warm", "nutty", "milky"],
        "flavors": ["spicy", "nutty", "complex", "cinnamon"]
    },
    "thriller": {
        "scents": ["spicy", "woody", "smokey", "powdery", "earthy"],
        "flavors": ["roasted", "bitter", "crispy", "smokey", "complex", "energizing"]
    },
    "dystopian": {
        "scents": ["metallic", "leather", "mineral", "earthy", "nutty"],
        "flavors": ["nutty", "zesty", "crispy"]
    },
    "historical fiction": {
        "scents": ["woody", "leather", "smokey", "tea-like"],
        "flavors": ["buttery", "roasted", "cinnamon", "complex"]
    },
    "non-fiction": {
        "scents": ["citrus", "herbal", "balsamic"],
        "flavors": ["sour", "creamy", "roasted"]
    },
    "mystery": {
        "scents": ["spicy", "smokey", "citrus", "nutty"],
        "flavors": ["nutty", "complex", "roasted", "energizing"]
    },
    "post-apocalyptic": {
        "scents": ["earthy", "smokey", "metallic", "boozy"],
        "flavors": ["roasted", "bold", "caramel"]
    },
    "young adult": {
        "scents": ["tea-like", "honeyed", "milky", "warm", "spicy", "creamy", "floral", "earthy"],
        "flavors": ["caramel", "zesty", "vanilla"]
    },
    "contemporary": {
        "scents": ["woody", "floral", "fruity", "earthy"],
        "flavors": ["herbal", "calm", "caramel"]
    },
    "literary fiction": {
        "scents": ["floral", "leather", "aromatic", "earthy"],
        "flavors": ["nutty", "bold", "roasted"]
    },
    "classics": {
        "scents": ["earthy", "woody", "smokey", "leather", "tea-like"],
        "flavors": ["roasted", "nutty", "caramel", "complex"]
    },
    "drama": {
        "scents": ["fruity", "creamy", "aromatic", "spicy"],
        "flavors": ["zesty", "nutty", "spicy"]
    }
}

ZODIAC_GENRES = {
    "aries": ["Thriller", "Fantasy", "Drama", "Science Fiction", "Post-Apocalyptic"],
    "taurus": ["Romance", "Historical Fiction", "Classics", "Literary Fiction", "Fiction"],
    "gemini": ["Mystery", "Science Fiction", "Contemporary", "Thriller", "Fiction"],
    "cancer": ["Historical Fiction", "Romance", "Drama", "Young Adult", "Literary Fiction"],
    "leo": ["Fantasy", "Romance", "Drama", "Historical Fiction", "Classics"],
    "virgo": ["Mystery", "Non-Fiction", "Science Fiction", "Classics", "Literary Fiction"],
    "libra": ["Romance", "Contemporary", "Drama", "Literary Fiction", "Classics"],
    "scorpio": ["Thriller", "Mystery", "Dystopian", "Post-Apocalyptic", "Drama"],
    "sagittarius": ["Fantasy", "Science Fiction", "Historical Fiction", "Adventure", "Fiction"],
    "capricorn": ["Historical Fiction", "Classics", "Non-Fiction", "Drama", "Literary Fiction"],
    "aquarius": ["Science Fiction", "Dystopian", "Contemporary", "Fantasy", "Non-Fiction"],
    "pisces": ["Fantasy", "Romance", "Drama", "Literary Fiction", "Fiction"]
}

DRINK_MAP = [
    {"drink": "Iced Brown Sugar Oatmilk Shaken Espresso", "flavors": ["sweet", "caramel", "creamy", "bold", "roasted"]},
    {"drink": "Lavender Honey Oatmilk Latte", "flavors": ["floral", "sweet", "creamy", "calming", "smooth"]},
    {"drink": "Matcha Latte with Vanilla Cold Foam", "flavors": ["earthy", "creamy", "sweet", "vanilla", "smooth"]},
    {"drink": "Dragonfruit Refresher with Coconut Milk", "flavors": ["fruity", "sweet", "creamy", "refreshing", "tropical"]},
    {"drink": "Salted Caramel Cream Cold Brew", "flavors": ["sweet", "caramel", "creamy", "bold", "rich"]},
    {"drink": "Pumpkin Cream Chai Latte", "flavors": ["spicy", "sweet", "creamy", "cinnamon", "warming"]},
    {"drink": "Brown Sugar Boba Milk Tea", "flavors": ["sweet", "caramel", "creamy", "rich", "smooth"]},
    {"drink": "Strawberry Matcha Latte", "flavors": ["fruity", "sweet", "earthy", "creamy", "refreshing"]},
    {"drink": "Turmeric Golden Milk Latte", "flavors": ["spicy", "earthy", "creamy", "warming", "herbal"]},
    {"drink": "Butterbeer Frappuccino", "flavors": ["sweet", "buttery", "creamy", "caramel", "rich"]},
    {"drink": "Midnight Mint Mocha", "flavors": ["chocolate", "minty", "creamy", "sweet", "cooling"]},
    {"drink": "Rose Cardamom Latte", "flavors": ["floral", "spicy", "creamy", "sweet", "warming"]},
    {"drink": "Coconut Cold Brew with Cinnamon", "flavors": ["nutty", "spicy", "bold", "refreshing", "creamy"]},
    {"drink": "Hazelnut White Chocolate Mocha", "flavors": ["nutty", "chocolate", "sweet", "creamy", "rich"]},
    {"drink": "Ube Violet Latte", "flavors": ["nutty", "sweet", "creamy", "earthy", "vanilla"]},
    # ... (Includes all drinks from the list)
]