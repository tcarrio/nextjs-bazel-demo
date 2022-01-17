def dedup(input_array):
    """Deduplicate items in an array

    Args:
      input_array: array to deduplicate

    Returns:
      deduplicated array
    """

    dedup_dict = {}
    dedup_array = []

    for item in input_array:
        if item not in dedup_dict:
            dedup_array.append(item)
            dedup_dict[item] = None

    return dedup_array
