import pytest
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))

from app.core.loader import load_yaml_file

def test_load_books_yaml():
    """Test that books.yaml loads correctly"""
    data = load_yaml_file('config/books.yaml')
    books = data.get('books', [])
    assert isinstance(books, list)
    assert len(books) > 0
    # Check required fields in first book
    first_book = books[0]
    assert 'title' in first_book
    assert 'author' in first_book
    assert 'main_genre' in first_book
    assert 'scent' in first_book
    print(f"✓ Loaded {len(books)} books")

def test_load_rules_yaml():
    """Test that rules.yaml has required sections"""
    rules = load_yaml_file('config/rules.yaml')
    assert 'zodiac' in rules
    assert 'coffee' in rules
    assert 'scoring' in rules
    assert 'penalties' in rules
    print("✓ Rules YAML structure is valid")

def test_load_perfumes_yaml():
    """Test perfumes.yaml structure"""
    data = load_yaml_file('config/perfumes.yaml')
    perfumes = data.get('perfumes', [])
    assert isinstance(perfumes, list)
    for perfume in perfumes[:3]:  # Check first 3
        assert 'name' in perfume
        assert 'brand' in perfume
        assert 'scent' in perfume
    print(f"✓ Loaded {len(perfumes)} perfumes")

def test_yaml_file_exists():
    """Ensure all YAML files exist"""
    required_files = [
        'config/books.yaml',
        'config/rules.yaml', 
        'config/perfumes.yaml',
        'config/drinks.yaml'
    ]
    for file_path in required_files:
        # Check if file exists in current dir or parent dir (for running from backend/)
        exists = os.path.exists(file_path) or os.path.exists(os.path.join('..', file_path))
        assert exists, f"Missing file: {file_path}"
    print("✓ All YAML files exist")