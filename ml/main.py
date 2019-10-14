"""Basic command-line interface for development and testing."""

import os

import pandas as pd
import matplotlib.pyplot as plt
# from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegressionCV
from sklearn.pipeline import make_pipeline

import clickbait
import sarcasm
import utils

DATA_DIR = "./data"

CLICKBAIT_DATA_FILE = os.path.join(DATA_DIR, "clickbait_data.txt")
NON_CLICKBAIT_DATA_FILE = os.path.join(DATA_DIR, "non_clickbait_data.txt")

SARCASM_DATA_FILE = os.path.join(DATA_DIR, "Sarcasm_Headlines_Dataset_v2.json")


def main():
    seed = 42

    clickbait_data = clickbait.read_clickbait_data(
        CLICKBAIT_DATA_FILE, NON_CLICKBAIT_DATA_FILE
    )

    sarcasm_data = sarcasm.read_sarcasm_data(SARCASM_DATA_FILE)

    # Concatenate both together
    # is_sarcastic and is_clickbait are considered equivalent
    combined_data = pd.DataFrame({
        "headline": pd.concat(
            (clickbait_data["headline"], sarcasm_data["headline"])),
        "is_clickbait": pd.concat(
            (clickbait_data["is_clickbait"], sarcasm_data["is_sarcastic"]))
    })

    # Create train/test split of data
    x_train, x_test, y_train, y_test = train_test_split(
        combined_data["headline"], combined_data["is_clickbait"]
    )

    # Instantiate TfidVectrorizer to translate text data to feature vectors
    # such that they can be used as inputs for an estimator
    tf_v = TfidfVectorizer()

    # With the vectorizer trained, let's load some different estimators
    clf = LogisticRegressionCV(cv=5, random_state=seed)

    pipe = make_pipeline(tf_v, clf)
    pipe.fit(x_train, y_train)

    predictions = pipe.predict(x_test)
    utils.print_evaluation(y_test, predictions)

    # CANNOT RUN DUE TO MEMORY
    # rfc = RandomForestClassifier(
    #     n_jobs=-1,
    #     n_estimators=1000,
    #     random_state=seed,
    #     verbose=3)
    # predictions = rfc.predict(x_test)
    # utils.print_evaluation(y_test, predictions)

    print("\n\nPlotting frequency of word use . . .")

    clickbait_headlines = \
        combined_data[combined_data["is_clickbait"]]["headline"]
    non_clickbait_headlines = \
        combined_data[~combined_data["is_clickbait"]]["headline"]

    utils.plot_freq(clickbait_headlines,
                    title="Words By Use In Clickbait Headlines")
    utils.plot_freq(non_clickbait_headlines,
                    title="Words By Use In Non-Clickbait titles")

    plt.show()


if __name__ == '__main__':
    main()
