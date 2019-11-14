"""Collect and aggregate all data."""

import os

import pandas as pd

import clickbait
import sarcasm

DATA_DIR = "./data"

CLICKBAIT_DATA_FILE = os.path.join(DATA_DIR, "clickbait_data.txt")
NON_CLICKBAIT_DATA_FILE = os.path.join(DATA_DIR, "non_clickbait_data.txt")

SARCASM_DATA_FILE = os.path.join(DATA_DIR, "Sarcasm_Headlines_Dataset_v2.json")

def read_all_data():
    """Read and combine both clickbait and sarcasm data."""

    clickbait_data = read_clickbait_data()
    sarcasm_data = read_sarcasm_data()

    # Concatenate both together
    # is_sarcastic and is_clickbait are considered equivalent
    return pd.DataFrame({
        "headline": pd.concat(
            (clickbait_data["headline"], sarcasm_data["headline"])),
        "is_clickbait": pd.concat(
            (clickbait_data["is_clickbait"], sarcasm_data["is_sarcastic"]))
    })


def read_clickbait_data():
    return clickbait.read_clickbait_data(
        CLICKBAIT_DATA_FILE, NON_CLICKBAIT_DATA_FILE)


def read_sarcasm_data():
    return sarcasm.read_sarcasm_data(SARCASM_DATA_FILE)
