from datetime import datetime
import os
from flask import Flask, jsonify, request
from playwright.sync_api import sync_playwright
import psycopg2

app = Flask(__name__)


def take_screenshot(url, save_dir="static/screenshots"):
  os.makedirs(save_dir, exist_ok=True, mode=0o777)
  filename = f"screenshot_{int(datetime.now().timestamp())}.png"
  filepath = os.path.join(save_dir, filename)

  try:
    with sync_playwright() as p:
      browser = p.chromium.launch(headless=True)
      page = browser.new_page()
      page.goto(url, timeout=10000)
      page.screenshot(path=filepath)
      browser.close()
    return filepath
  except Exception as e:
    print(f"Screenshot failed: {e}")
    return "error_capture.png"


@app.route("/splunk-webhook", methods=["POST"])
def splunk_webhook():
  data = request.json
  # Extract fields sent by Splunk
  alert_name = data.get("result", {}).get("name", "Unknown Alert")
  severity = data.get("result", {}).get("severity", "Medium")
  url = data.get("result", {}).get(
      "url", "http://example.com"
  )  # The URL to capture

  # Capture Timestamp & Screenshot
  arrival_time = datetime.now()
  screenshot_path = take_screenshot(url)

  # Save to SQL Database
  try:
    conn = psycopg2.connect(
        dbname="your_db", user="your_user", password="your_password", host="localhost"
    )
    cur = conn.cursor()
    cur.execute(
        """INSERT INTO alert_logs (alert_name, severity, target_url, screenshot_path, arrival_time) 
               VALUES (%s, %s, %s, %s, %s)""",
        (alert_name, severity, url, screenshot_path, arrival_time),
    )
    conn.commit()
    cur.close()
    conn.close()
  except Exception as db_error:
    print(f"Database error: {db_error}")

  return jsonify({"status": "success", "message": "Alert processed"}), 200


if __name__ == "__main__":
  app.run(host="0.0.0.0", port=5000)
