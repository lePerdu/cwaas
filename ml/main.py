"""Basic command-line interface for development and testing."""

import sys
import os

import pandas as pd
import matplotlib.pyplot as plt
# from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegressionCV
from sklearn.pipeline import make_pipeline

from data import read_all_data
import utils


def main():
    seed = 9001

    combined_data = read_all_data()

    # Create train/test split of data
    x_train, x_test, y_train, y_test = train_test_split(
        combined_data["headline"],
        combined_data["is_clickbait"],
        random_state=seed
    )

    if len(sys.argv) > 1:
        print()
        print("Loading pickle...")
        print()

        pipe = utils.unpickle_gzip("pipeline.pickle.gz")
    else:
        print()
        print("Training...")
        print()

        # Instantiate TfidVectrorizer to translate text data to feature vectors
        # such that they can be used as inputs for an estimator
        tf_v = TfidfVectorizer(strip_accents='unicode')

        # With the vectorizer trained, let's load some different estimators
        clf = LogisticRegressionCV(
            cv=5,
            solver='saga',
            random_state=seed,
        )

        pipe = make_pipeline(tf_v, clf)

        pipe.fit(x_train, y_train)

    print()
    print("Predicting...")
    print()

    predictions = pipe.predict(x_test)
    utils.print_evaluation(y_test, predictions)

    if len(sys.argv) <= 1:
        print()
        print("Pickling...")
        print()

        utils.pickle_gzip(pipe, "pipeline.pickle.gz")

    # CANNOT RUN DUE TO MEMORY
    # rfc = RandomForestClassifier(
    #     n_jobs=-1,
    #     n_estimators=1000,
    #     random_state=seed,
    #     verbose=3)
    # predictions = rfc.predict(x_test)
    # utils.print_evaluation(y_test, predictions)

    print("\n\nPlotting frequency of word use . . .")
    plot_split_word_freqs(
        combined_data,
        tf_v.build_preprocessor(),
        tf_v.build_tokenizer()
    )


def plot_split_word_freqs(data, preproc, tokenize):
    """Make word frequency plots for clickbait and non-clickbait headlines."""
    clickbait_headlines = data[data["is_clickbait"]]["headline"]
    non_clickbait_headlines = data[~data["is_clickbait"]]["headline"]

    utils.plot_freq(clickbait_headlines,
                    preproc,
                    tokenize,
                    title="Words By Use In Clickbait Headlines")
    utils.plot_freq(non_clickbait_headlines,
                    preproc,
                    tokenize,
                    title="Words By Use In Non-Clickbait titles")

    plt.show()


if __name__ == '__main__':
    main()
