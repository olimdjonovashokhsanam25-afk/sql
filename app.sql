CREATE TABLE alert_logs (
    id SERIAL PRIMARY KEY,
    alert_name VARCHAR(255),
    severity VARCHAR(50), -- High, Medium, Low
    target_url TEXT,
    screenshot_path VARCHAR(255),
    arrival_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
