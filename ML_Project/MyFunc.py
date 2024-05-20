def classify_row(value):
    """ Function that check if or contains word Dwelling

    Args:
        value -> value from column

    Return: returns string Business or Non-Business
    
    """
    if 'Dwelling' in value:
        return 'Business '
    else:
        return 'Non-Business'