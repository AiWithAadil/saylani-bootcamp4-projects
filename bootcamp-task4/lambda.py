import json
import csv
import boto3
import os
import requests
from bs4 import BeautifulSoup
from datetime import datetime

S3_BUCKET = os.environ.get('S3_BUCKET_NAME', 'mufap-scraper-data')

def lambda_handler(event, context):
    try:
        url = 'https://www.mufap.com.pk/Industry/IndustryStatDaily?tab=3'
        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        table = soup.select_one('table')

        # Extract headers
        headers = [th.text.strip() for th in table.select('thead th')]

        # Extract rows
        data = []
        for row in table.select('tbody tr'):
            cells = row.find_all('td')
            if cells:
                row_data = {headers[i]: cells[i].text.strip() for i in range(len(cells))}
                data.append(row_data)

        # Save CSV to /tmp
        today = datetime.now().strftime('%Y-%m-%d')
        filename = f'mufap_nav_{today}.csv'
        local_path = f'/tmp/{filename}'
        with open(local_path, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=headers)
            writer.writeheader()
            writer.writerows(data)

        # Upload to S3
        s3 = boto3.client('s3')
        s3_path = f'daily/{filename}'
        s3.upload_file(local_path, S3_BUCKET, s3_path)

        return {
            'statusCode': 200,
            'body': json.dumps({'rows': len(data), 's3_path': f's3://{S3_BUCKET}/{s3_path}'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }