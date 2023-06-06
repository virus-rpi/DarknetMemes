FROM python:3.11-slim-buster

# Set the working directory in the container
WORKDIR /app

# Install Tor and supervisord
RUN apt-get update && apt-get install -y tor supervisor

# Create the torrc file
RUN echo "HiddenServiceDir /var/lib/tor/hidden_service" >> /etc/tor/torrc
RUN echo "HiddenServicePort 80 127.0.0.1:5000" >> /etc/tor/torrc

# Copy the requirements file
COPY requirements.txt .

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Flask application code into the container
COPY . .

# Expose the port for the Flask application
EXPOSE 5000

# Create the supervisord.conf file
RUN echo "[supervisord]" > /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:tor]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=tor" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:flask]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=flask run --host=0.0.0.0 --port=5000" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "redirect_stderr=true" >> /etc/supervisor/conf.d/supervisord.conf

# Start supervisord to manage Tor and Flask processes
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
