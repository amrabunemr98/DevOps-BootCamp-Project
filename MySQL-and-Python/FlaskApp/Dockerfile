FROM python:3.8
WORKDIR /app
COPY FlaskApp/requirements.txt .
RUN pip install -r requirements.txt
COPY FlaskApp/ .
CMD [ "python3" , "app.py" ]
