"""Miscellaneous helper functions."""

import pickle
import pickletools
import gzip

from collections import Counter

import pandas as pd
import matplotlib.pyplot as plt
from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    classification_report,
)


def print_evaluation(y_true, y_pred):
    """Prints some classification reports."""
    print(f"accuracy = {accuracy_score(y_true, y_pred)}")
    print(f"precision = {precision_score(y_true, y_pred)}")
    print(f"recall = {recall_score(y_true, y_pred)}")
    print()
    print(classification_report(y_true, y_pred))


def word_counts(headlines, n=None):
    """Makes a DataFrame with the most common words.
    Arguments:
    headlines - Headlines to look.
    n - Number of most common words to extract (None for all of the words).

    Returns:
    A DataFrame with the columns "word" and "count".
    """
    counter = Counter(word.strip().lower() for hl in headlines for word in hl.split())
    return pd.DataFrame(counter.most_common(n), columns=("word", "count"))


def plot_freq(headlines, n=40, title="Word Frequency"):
    """Plots the frequency of the n words."""

    counts = word_counts(headlines, n)

    plt.figure(figsize=(20, 8))
    plt.title(title)
    plt.xticks(rotation=-45)
    plt.bar(counts["word"], counts["count"])


def pickle_gzip(obj, filename):
    p = pickletools.optimize(pickle.dumps(obj))
    with gzip.open(filename, 'wb') as f:
        f.write(p)


def unpickle_gzip(filename):
    with gzip.open(filename) as f:
        return pickle.load(f)
