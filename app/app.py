from flask import Flask, render_template, request
import requests
from datetime import datetime, timedelta
import os
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

# Initialize Prometheus Metrics
metrics = PrometheusMetrics(app)

# Define custom metrics if needed
REQUEST_COUNT = metrics.counter(
    'app_request_count', 'Total number of requests',
    labels={'endpoint': lambda: request.endpoint}
)

ERROR_COUNT = metrics.counter(
    'app_error_count', 'Total number of error responses',
    labels={'endpoint': lambda: request.endpoint, 'status': lambda: getattr(request, 'status_code', 200)}
)

# Load API key from environment variables for better security
API_KEY = os.getenv("OPENWEATHER_API_KEY")
BASE_URL = "http://api.openweathermap.org/data/2.5/weather"


@app.route('/', methods=['GET', 'POST'])
@REQUEST_COUNT
def index():
    weather_data = None
    local_time = None
    try:
        if request.method == 'POST':
            city = request.form['city']
            params = {
                'q': city,
                'appid': API_KEY,
                'units': 'metric'
            }
            response = requests.get(BASE_URL, params=params)
            response.raise_for_status()  # Raise HTTPError for bad responses
            weather_data = response.json()

            if weather_data and weather_data.get('timezone'):
                utc_time = datetime.utcnow()
                timezone_offset = weather_data['timezone']
                local_time = utc_time + timedelta(
                    seconds=timezone_offset
                )
                local_time = local_time.strftime('%Y-%m-%d %H:%M:%S')
    except requests.exceptions.RequestException as e:
        ERROR_COUNT.labels(status=500).inc()
        weather_data = {'error': str(e)}
        local_time = 'Unavailable'

    return render_template('index.html', weather_data=weather_data, local_time=local_time)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
