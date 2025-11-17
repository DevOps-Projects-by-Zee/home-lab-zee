from flask import Flask, jsonify, request
import psycopg2
import time
import random
import logging
import os
from datetime import datetime
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Prometheus metrics
REQUEST_COUNT = Counter('flask_app_requests_total', 'Total requests', ['method', 'endpoint', 'status'])
REQUEST_DURATION = Histogram('flask_app_request_duration_seconds', 'Request duration')

# Database configuration
DB_CONFIG = {
    'host': '192.168.56.12',  # Database VM IP
    'database': 'app_db',
    'user': 'postgres',
    'password': 'secretpassword',
    'port': 5432
}

def get_db_connection():
    """Get database connection with error handling"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except psycopg2.Error as e:
        logger.error(f"Database connection failed: {e}")
        return None

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request  
def after_request(response):
    duration = time.time() - request.start_time
    REQUEST_DURATION.observe(duration)
    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.endpoint or 'unknown',
        status=response.status_code
    ).inc()
    return response

@app.route('/')
def index():
    """Root endpoint - API information"""
    return jsonify({
        'name': 'Flask App API',
        'version': '1.0.0',
        'endpoints': {
            'health': '/health',
            'users': '/api/users',
            'stress': '/api/stress',
            'metrics': '/metrics'
        }
    }), 200

@app.route('/health')
def health_check():
    """Comprehensive health check"""
    health_status = {
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'checks': {}
    }
    
    # Check database connection
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute('SELECT 1')
            cursor.close()
            conn.close()
            health_status['checks']['database'] = 'healthy'
        except Exception as e:
            health_status['checks']['database'] = f'unhealthy: {str(e)}'
            health_status['status'] = 'unhealthy'
    else:
        health_status['checks']['database'] = 'unhealthy: connection failed'
        health_status['status'] = 'unhealthy'
    
    # Check memory usage (simulate)
    health_status['checks']['memory'] = 'healthy'
    
    status_code = 200 if health_status['status'] == 'healthy' else 503
    return jsonify(health_status), status_code

@app.route('/api/users', methods=['GET'])
def get_users():
    """Get all users - this endpoint will be stressed"""
    # Simulate some processing time
    time.sleep(random.uniform(0.1, 0.5))
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor()
        cursor.execute('SELECT id, username, email, created_at FROM users ORDER BY id')
        users = []
        for row in cursor.fetchall():
            users.append({
                'id': row[0],
                'username': row[1], 
                'email': row[2],
                'created_at': row[3].isoformat() if row[3] else None
            })
        
        cursor.close()
        conn.close()
        
        # Log to database for monitoring
        log_request('INFO', f'Retrieved {len(users)} users')
        
        return jsonify({'users': users, 'count': len(users)})
        
    except Exception as e:
        logger.error(f"Error fetching users: {e}")
        return jsonify({'error': 'Failed to fetch users'}), 500

@app.route('/api/users', methods=['POST'])
def create_user():
    """Create new user"""
    data = request.get_json()
    
    if not data or 'username' not in data or 'email' not in data:
        return jsonify({'error': 'Missing username or email'}), 400
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = conn.cursor()
        cursor.execute(
            'INSERT INTO users (username, email) VALUES (%s, %s) RETURNING id',
            (data['username'], data['email'])
        )
        user_id = cursor.fetchone()[0]
        conn.commit()
        cursor.close()
        conn.close()
        
        log_request('INFO', f'Created user: {data["username"]}')
        
        return jsonify({
            'id': user_id,
            'username': data['username'],
            'email': data['email']
        }), 201
        
    except psycopg2.IntegrityError:
        return jsonify({'error': 'Username or email already exists'}), 409
    except Exception as e:
        logger.error(f"Error creating user: {e}")
        return jsonify({'error': 'Failed to create user'}), 500

@app.route('/api/stress', methods=['GET'])
def stress_endpoint():
    """Endpoint designed to cause problems under load"""
    # Simulate expensive operation
    time.sleep(random.uniform(1, 3))
    
    # Sometimes fail randomly (10% chance)
    if random.random() < 0.1:
        return jsonify({'error': 'Random failure for testing'}), 500
    
    # Do some "heavy" computation
    result = sum(i * i for i in range(10000))
    
    return jsonify({
        'message': 'Expensive operation completed',
        'result': result,
        'timestamp': datetime.now().isoformat()
    })

@app.route('/metrics')
def metrics():
    """Prometheus metrics endpoint"""
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

def log_request(level, message):
    """Log request to database"""
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute(
                'INSERT INTO app_logs (level, message, source) VALUES (%s, %s, %s)',
                (level, message, 'flask-app')
            )
            conn.commit()
            cursor.close()
            conn.close()
        except Exception as e:
            logger.error(f"Failed to log to database: {e}")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)