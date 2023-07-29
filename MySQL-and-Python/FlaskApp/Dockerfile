FROM python:3.8

# Set the working directory inside the container to /app
WORKDIR /app

# Copy the requirements.txt file from the host to the /app directory in the container
COPY MySQL-and-Python/FlaskApp/requirements.txt /app/

# Install the Python dependencies listed in requirements.txt using pip
RUN pip install -r requirements.txt

# Copy the rest of the FlaskApp files from the host to the /app directory in the container
COPY MySQL-and-Python/FlaskApp /app

# Set the command to be executed when the container starts
CMD ["python3", "app.py"]


