#!/usr/bin/env sh

# server refers to the server.py module. 
gunicorn --bind 0.0.0.0:$PORT server:app