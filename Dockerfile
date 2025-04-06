FROM python:3.9

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app/ app/
WORKDIR /app/app
CMD ["python", "routes.py"]
