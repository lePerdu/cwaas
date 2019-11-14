from http import HTTPStatus

import numpy as np
from flask import Flask, request

from ml.data import read_all_data
from ml.utils import unpickle_gzip

app = Flask(__name__)

# Load this once
model = unpickle_gzip("models/pipeline.pickle.gz")


# TODO Make this POST?
@app.route('/testHeadline', methods=('GET',))
def test_headline():
    headline = request.args.get('headline')
    if headline is None:
        return {
            'error': "Query parameter `headline' is required",
        }, HTTPStatus.BAD_REQUEST

    cb_prob = model.predict_proba((headline,))[0, 1]
    print(f"{headline}: {cb_prob}")

    return {
        'data': {
            'headline': headline,
            'clickbait': bool(cb_prob > 0.5),
            'probability': cb_prob,
        },
    }
