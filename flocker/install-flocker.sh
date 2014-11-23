#!/bin/sh

sudo apt-get install gcc python2.7 python-virtualenv python2.7-dev

VIR_ENV=flocker-virtualenv

# Create a virtualenv, an isolated Python environment, in a new directory called
# "flocker-tutorial":
virtualenv --python=/usr/bin/python2.7 $VIR_ENV

# Upgrade the pip Python package manager to its latest version inside the
# virtualenv. Some older versions of pip have issues installing Python wheel
# packages.
$VIR_ENV/bin/pip install --upgrade pip

# Install flocker-cli and dependencies inside the virtualenv:
echo "Installing Flocker and dependencies, this may take a few minutes with no output to the terminal..."
$VIR_ENV/bin/pip install --quiet https://storage.googleapis.com/archive.clusterhq.com/downloads/flocker/Flocker-0.3.0-py2-none-any.whl
echo "Done!"
