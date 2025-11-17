-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Create application logs table  
CREATE TABLE IF NOT EXISTS app_logs (
    id SERIAL PRIMARY KEY,
    level VARCHAR(10) NOT NULL,
    message TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source VARCHAR(50)
);

-- Insert sample data
INSERT INTO users (username, email) VALUES 
    ('admin', 'admin@company.com'),
    ('testuser', 'test@company.com'),
    ('devuser', 'dev@company.com');

-- Create index for performance
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_logs_timestamp ON app_logs(timestamp);