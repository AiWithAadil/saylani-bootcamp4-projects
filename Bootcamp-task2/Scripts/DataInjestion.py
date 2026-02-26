import sys
import os

os.environ['KAGGLE_CACHE_DIR'] = '/tmp'
os.environ['HOME'] = '/tmp'
os.environ['XDG_CACHE_HOME'] = '/tmp'

import kagglehub
from kagglehub import KaggleDatasetAdapter
import boto3

# Kaggle credentials
os.environ['KAGGLE_USERNAME'] = '*******'
os.environ['KAGGLE_KEY'] = '***************'

# Fetch dataset from Kaggle
df = kagglehub.load_dataset(
    KaggleDatasetAdapter.PANDAS,
    "ulrikthygepedersen/online-retail-dataset",
    "online_retail.csv"
)

print(f"Dataset loaded: {df.shape}")

# Save to /tmp
df.to_csv('/tmp/raw_data.csv', index=False)

# Upload to S3
s3 = boto3.client('s3')
s3.upload_file(
    '/tmp/raw_data.csv', 
    'bootcamp-task1-ad',
    'raw-data/raw_data.csv'
)

print("Data ingested successfully to S3!")