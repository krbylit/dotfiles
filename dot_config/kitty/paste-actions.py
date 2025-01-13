def filter_paste(text):
    # Strip newlines from the pasted text so pasted commands are not
    # immediately executed
    return text.rstrip()
