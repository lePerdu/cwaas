"""Clickbait headline data processing."""

import numpy as np
import pandas as pd


def read_clickbait_data(clickbait_file, nonclickbait_file):
    """Reads clickbait data into a DataFrame.
    Returns:
    DataFrame with columns "headline" and "is_clickbait"
    """

    clickbait_data = read_lines(clickbait_file)
    nonclickbait_data = read_lines(nonclickbait_file)
    all_data = pd.concat((clickbait_data, nonclickbait_data), ignore_index=True)
    labels = np.zeros_like(all_data, dtype=bool)
    labels[: len(clickbait_data)] = True

    return pd.DataFrame({"headline": all_data, "is_clickbait": labels})


def read_lines(path):
    """Reads an individual file.
    Each files contains 1 headline per line, with empty lines in between
    entries.
    """
    with open(path, encoding="utf8") as f:
        return pd.Series(filter(lambda l: len(l) > 0, (l.strip() for l in f)))
