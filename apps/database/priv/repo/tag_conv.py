#!/usr/bin/env python3

from typing import Dict, List

FILE = "taglist.txt"

def replace_quotes(string: str) -> str:
    return string.replace("'", '"')

def main() -> None:
    config = """use Mix.Config

config :database, :tag_translations, %{
"""

    tag_map: Dict[str, List[str]] = {}

    with open(FILE, 'r') as f:
        lines: List[str] = f.readlines()

    for line in lines:
        parts: List[str] = line.strip().split(';')
        internal = parts[0]
        if len(parts) > 1:
            external = parts[1:-1]
        else:
            external = []
        for tag in external:
            if tag not in tag_map:
                tag_map[tag] = [internal]
            else:
                tag_map[tag].append(internal)

    for nexus_tag, our_tags in tag_map.items():
        config = f'{config}  "{nexus_tag}" => {replace_quotes(str(our_tags))},\n'

    config = f'{config}}}'

    print(config)

if __name__ == "__main__":
    main()
