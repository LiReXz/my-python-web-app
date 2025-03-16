# Use the official Python image as the base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the dependencies file (requirements.txt) and install the dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire application code into the container
COPY . .

# Expose port 5000 so the Flask application can be accessed
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
