from http import HTTPStatus

import numpy as np
from flask import Flask, request

from ml.data import read_all_data
from ml.utils import unpickle_gzip

app = Flask(__name__)

# Load these once
model = unpickle_gzip("models/pipeline.pickle.gz")
all_data = read_all_data()


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


@app.route('/sampleHeadline', methods=('GET',))
def sample_headline():
    get_clickbait = request.args.get('clickbait')

    if get_clickbait is None:
        # Select from all of the data
        idx = np.random.randint(len(all_data))
        element = all_data.iloc[idx]
    else:
        if get_clickbait == "False" or get_clickbait == "false":
            get_clickbait = False
        elif get_clickbait == "True" or get_clickbait == "true":
            get_clickbait = True
        else:
            return {
                'error':
                    "Query parameter `clickbait' must be `True' or `False'",
            }, HTTPStatus.BAD_REQUEST

        # Just select from one particular set
        indices = np.argwhere(
            all_data['is_clickbait'].to_numpy() == get_clickbait)[:, 0]
        idx = np.random.choice(indices)
        element = all_data.iloc[idx]

    return {
        'data': {
            'headline': element['headline'],
            'clickbait': bool(element['is_clickbait']),
        },
    }
