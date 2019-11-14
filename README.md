# Click-Worthiness-as-a-Service

> To click, or not to click, that is the question

... that we are trying to answer automatically, once and for all, by using
machine learning.


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


## Running

The current entry point is `ml/main.py`, which trains the classifier and does
some basic evaluation and visualization.
