#!/bin/bash

echo "Setting up environment..."

python3 -m venv venv
source venv/bin/activate

pip install -r backend/requirements.txt

echo "Setup complete."
