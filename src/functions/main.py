import base64
import json
import numpy as np
import pandas as pd
import pickle
import joblib
import sklearn
from google.cloud import storage, pubsub_v1
import google.cloud.logging
import logging
from io import BytesIO

client = google.cloud.logging.Client(project="project")
client.setup_logging()

def hello_pubsub(cloud_event,context):
    # Print out the data from Pub/Sub, to prove that it worked
    print("prod-started")
    logging.info(f"Successfully worked")