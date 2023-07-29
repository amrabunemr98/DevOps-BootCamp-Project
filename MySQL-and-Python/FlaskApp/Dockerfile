FROM python:3.8
WORKDIR /app
COPY MySQL-and-Python/FlaskApp/requirements.txt /app/
RUN pip install -r requirements.txt
COPY MySQL-and-Python/FlaskApp /app
CMD ["python3", "app.py"]

