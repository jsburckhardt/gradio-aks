FROM python:3.11-slim-bullseye

COPY requirements.txt /app/
COPY src/* /app/

WORKDIR /app

RUN pip install -r requirements.txt

EXPOSE 7860

CMD ["python", "app.py"]
