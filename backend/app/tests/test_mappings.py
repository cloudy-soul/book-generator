import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

from app.core.mappings import GENRE_MAP, ZODIAC_GENRES, DRINK_MAP

def test_genre_map_structure():
    """Ensure GENRE_MAP has the expected structure and keys."""
    assert "romance" in GENRE_MAP
    assert "scents" in GENRE_MAP["romance"]
    assert "flavors" in GENRE_MAP["romance"]
    
    # Check a specific relationship
    assert "floral" in GENRE_MAP["romance"]["scents"]

def test_zodiac_genres_structure():
    """Ensure all 12 zodiac signs are present and have genre lists."""
    assert len(ZODIAC_GENRES) == 12
    assert "aries" in ZODIAC_GENRES
    assert isinstance(ZODIAC_GENRES["aries"], list)
    
    # Check a specific relationship
    assert "Thriller" in ZODIAC_GENRES["aries"]

def test_drink_map_structure():
    """Ensure DRINK_MAP is a list of dictionaries with drinks and flavors."""
    assert isinstance(DRINK_MAP, list)
    assert len(DRINK_MAP) > 0
    assert "drink" in DRINK_MAP[0]
    assert "flavors" in DRINK_MAP[0]