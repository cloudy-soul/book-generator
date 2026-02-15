import yaml
import os

def load_yaml_file(filepath):
    """Load YAML file and return parsed data"""
    # List of paths to check: current, parent (../), and config/ subdirectory variations
    paths_to_check = [
        filepath,
        os.path.join('..', filepath),
        os.path.join('config', os.path.basename(filepath)),
        os.path.join('..', 'config', os.path.basename(filepath))
    ]

    for path in paths_to_check:
        if os.path.exists(path):
            with open(path, 'r', encoding='utf-8') as file:
                return yaml.safe_load(file)
    
    raise FileNotFoundError(f"Could not find file '{filepath}' in {paths_to_check}")