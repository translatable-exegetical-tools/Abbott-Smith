import re
import unicodedata
import os

def normalize_unicode(text):
    """
    Normalize ambiguous Unicode characters.

    Args:
        text: The string to normalize

    Returns:
        Normalized string
    """
    # Normalize to NFC form (canonical decomposition followed by canonical composition)
    return unicodedata.normalize('NFC', text)

def identify_and_fix_duplicate_key_attributes(xml_file, output_file):
    """
    Fix elements with duplicate key attributes in an XML file.

    Args:
        xml_file: Path to the input XML file
        output_file: Path to save the fixed XML file

    Returns:
        Tuple of (fixed content, number of elements fixed)
    """
    with open(xml_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Normalize Unicode
    content = normalize_unicode(content)

    # Pattern to match elements with key attributes
    # This pattern looks for tags that have two key attributes
    pattern = re.compile(r'<([^>]*?)key="([^"]*?)"([^>]*?)key="([^"]*?)"([^>]*?)>', re.DOTALL)

    fixed_count = 0
    position = 0
    fixed_content = ""

    # Find all matches
    for match in pattern.finditer(content):
        # Add content up to this match
        fixed_content += content[position:match.start()]
        position = match.end()

        start_tag = match.group(1)
        key1 = match.group(2)
        middle_tag = match.group(3)
        key2 = match.group(4)
        end_tag = match.group(5)

        # Determine which key is the lemma and which is the Strong's number
        # Strong's numbers typically follow patterns like G1234 or H1234
        if re.match(r'[GH]\d+', key1) and not re.match(r'[GH]\d+', key2):
            # key1 is Strong's, key2 is lemma
            strong_num = key1
            lemma = key2
        elif re.match(r'[GH]\d+', key2) and not re.match(r'[GH]\d+', key1):
            # key2 is Strong's, key1 is lemma
            strong_num = key2
            lemma = key1
        else:
            # Can't clearly determine which is which, keep the first one
            # (this is a fallback and might need adjustment based on your data)
            lemma = key1
            strong_num = key2

        # Create a new element with only the lemma as the key attribute
        # and add the Strong's number as a new attribute called 'strongs'
        new_element = f"<{start_tag}key=\"{lemma}\"{middle_tag}strongs=\"{strong_num}\"{end_tag}>"
        fixed_content += new_element

        fixed_count += 1

    # Add any remaining content
    fixed_content += content[position:]

    # Write the fixed content to the output file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(fixed_content)

    return fixed_content, fixed_count

def find_all_duplicate_key_elements(xml_file):
    """
    Find all elements with duplicate key attributes in an XML file.

    Args:
        xml_file: Path to the XML file

    Returns:
        List of matching elements with context
    """
    with open(xml_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Pattern to match elements with key attributes
    pattern = re.compile(r'<([^>]*?)key="([^"]*?)"([^>]*?)key="([^"]*?)"([^>]*?)>', re.DOTALL)

    matches = []

    for match in pattern.finditer(content):
        # Get some context around the match for display
        start_pos = max(0, match.start() - 50)
        end_pos = min(len(content), match.end() + 50)
        context = content[start_pos:end_pos]

        # Extract the two key values
        key1 = match.group(2)
        key2 = match.group(4)

        matches.append((context, key1, key2))

    return matches

if __name__ == "__main__":
    input_file = "abbott-smith.tei.xml"
    output_file = "abbott-smith.tei.fixed.xml"

    print("Finding elements with duplicate key attributes...")
    duplicate_elements = find_all_duplicate_key_elements(input_file)

    if duplicate_elements:
        print(f"Found {len(duplicate_elements)} elements with duplicate key attributes.")
        print("\nSample of the issues (first 5):")
        for i, (context, key1, key2) in enumerate(duplicate_elements[:5]):
            print(f"\n{i+1}. Element with keys: '{key1}' and '{key2}'")
            print(f"Context: ...{context}...")

        print("\nFixing issues...")
        _, fixed_count = identify_and_fix_duplicate_key_attributes(input_file, output_file)
        print(f"Fixed {fixed_count} elements with duplicate key attributes.")
        print(f"Fixed XML saved to {output_file}")
    else:
        print("No elements with duplicate key attributes found.")