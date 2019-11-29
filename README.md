# Click-Worthiness-as-a-Service

> To click, or not to click, that is the question

... that we are trying to answer automatically, once and for all, by using
machine learning.


## Code Layout

This project is hosted on Github and deployed using Github Pages and Heroku,
web-accessible at https://clickworthiness.online.

### Machine Learning

The back end is developed usng Python, with the [scikit-learn](scikit-learn.org)
library. Machine-learning and data-processing protions of the code are in the
`ml/` subdirectory. `main.py` is used to train the model, exporting a
[pickle](https://docs.python.org/3/library/pickle.html) file to `models/`.

### Front End

The front end is coded in [Elm](https://elm-lang.org) and deployed using
[Github Pages](https://pages.github.com). We have the domain
clickworthiness.online, registered using [Domain.com](https://domain.com),
which can be accessed gobally.

### Back End

Server code is in the `server/` subdirectory. It uses the
[Flask](https://www.fullstackpython.com/flask.html) framework to make a
simple JSON api which uses the model trained by `main.py`. The server is
deployed with the pickle to [Heroku](https://heroku.com) and hosted at
https://clickworthiness.herokuapp.com (CORS is enabled so that it can be
accessed from the clickworthiness.online domain).


## Development Setup

To minimize dependency problems, it is recommended to use a
[virtual environment](https://docs.python.org/3/tutorial/venv.html). Basic setup
is:

```
# Create a virtual environment
python3 -m venv venv


# On Mac or Linux
source venv/bin/activate

# On Windows cmd.exe
venv\Scripts\activate.bat

# On Windows PowerShell
venv\Scripts\Activate.ps1


# Install packages
pip install -r requirements.txt
```

Once the virtual environment has been created and the packages have been
installed, it can just be entered by running the `activate` script.
