"""Sarcasm headline data processing."""

import pandas as pd


def read_sarcasm_data(datafile):
    """Reads clickbait data into a DataFrame.
    Returns:
    DataFrame with columns "headline" and "is_sarcastic"
    """

    data = pd.read_json(
        datafile,
        orient="records",
        dtype={"is_sarcastic": bool})
    # We don't care about this (for now at least)
    del data["article_link"]

    return data
