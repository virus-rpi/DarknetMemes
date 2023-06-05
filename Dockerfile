# Use the official Python base image
FROM python:3.11-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Flask application code into the container
COPY . .

# Expose the port on which the Flask application will run
EXPOSE 5000

# Run the Flask application
CMD [ "flask", "run","--host","0.0.0.0","--port","5000"]