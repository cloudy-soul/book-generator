from typing import List, Dict
import difflib

def _perfume_tokens(perfume: Dict) -> List[str]:
    perf_scent = perfume.get('scent') or ''
    return [t.lower().strip() for t in perf_scent.split(',') if t.strip()]

def _tokens_similar(a: str, b: str) -> bool:
    a = a.lower().strip()
    b = b.lower().strip()
    if a in b or b in a:
        return True
    if a[:4] and a[:4] in b:
        return True
    if b[:4] and b[:4] in a:
        return True
    matches = difflib.get_close_matches(a, [b], n=1, cutoff=0.7)
    return bool(matches)

def select_perfume(perfumes: List[Dict], top_book: Dict, user_input: Dict, rules: Dict) -> Dict:
    """Select a perfume based on user scent, coffee hints, then top book scents."""
    selected = perfumes[0] if perfumes else {}
    user_scent = user_input.get('scent')
    user_coffee = user_input.get('coffee')
    coffee_rules = rules.get('coffee', {}).get(user_coffee, {}) if user_coffee else {}

    matched = False
    # 1) by user scent
    if isinstance(user_scent, str):
        us = user_scent.lower().strip()
        for perfume in perfumes:
            if any(_tokens_similar(us, pt) for pt in _perfume_tokens(perfume)):
                selected = perfume
                matched = True
                break

    # 2) coffee hints
    if not matched and coffee_rules:
        hints = coffee_rules.get('perfumes', [])
        for hint in hints:
            h = hint.lower()
            for perfume in perfumes:
                if any(_tokens_similar(h, pt) for pt in _perfume_tokens(perfume)):
                    selected = perfume
                    matched = True
                    break
            if matched:
                break

    # 3) book scent fallback
    if not matched and top_book:
        book_scents = [s.lower().strip() for s in (top_book.get('scent') or []) if isinstance(s, str)]
        for perfume in perfumes:
            if any(any(_tokens_similar(bs, pt) for pt in _perfume_tokens(perfume)) for bs in book_scents):
                selected = perfume
                matched = True
                break

    return selected
