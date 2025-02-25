import os
import time
import requests
import logging
import json
import argparse
from dotenv import load_dotenv

# Parse arguments
parser = argparse.ArgumentParser(description="Health Check Script")
parser.add_argument("-f", "--file", type=str, default=".env", help="Path to .env file")
args = parser.parse_args()

# Load environment variables from specified .env file
load_dotenv(args.file)

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Load configuration from environment variables or default values
HEALTH_ENDPOINT = os.getenv("HEALTH_ENDPOINT", "http://localhost:8000/health")
CHECK_INTERVAL = int(os.getenv("CHECK_INTERVAL", 300))  # Default: 5 minutes
RESPONSE_TIME_THRESHOLD = float(os.getenv("RESPONSE_TIME_THRESHOLD", 3.0))


def send_alert(severity,message):
    """Mock function to send an alert (e.g., email, Slack, etc.)."""
    logging.error(f"{severity}: {message}")


def perform_health_check():
    """Performs a health check on the configured endpoint."""
    try:
        start_time = time.time()
        response = requests.get(HEALTH_ENDPOINT, timeout=5)
        response_time = time.time() - start_time

        status_code = response.status_code
        #health_data = response.json() if response.headers.get('Content-Type') == 'application/json' else {}
        # If the Content-Type is missing or incorrect, the script will still try to parse the JSON response.
        try:
            health_data = response.json()
        except json.JSONDecodeError:
            health_data = {}
        
        log_message = {
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
            "endpoint": HEALTH_ENDPOINT,
            "response_time": response_time,
            "status_code": status_code,
            "health_data": health_data
        }
        logging.info(json.dumps(log_message))

        if response_time > RESPONSE_TIME_THRESHOLD:
            send_alert("HIGH",f"High response time: {response_time:.2f}s")

        if status_code != 200:
            send_alert("CRITICAL",f"Unexpected status code: {status_code}")

        if health_data.get("message") != "It' works":
            send_alert("CRITICAL","Connectivity issue detected")
    
    except requests.exceptions.RequestException as e:
        send_alert("CRITICAL",f"Health check failed: {e}")


if __name__ == "__main__":
    while True:
        perform_health_check()
        time.sleep(CHECK_INTERVAL)
