FROM python:3.9-slim

WORKDIR /app

COPY DevOps/Hermes/docker/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY Hermes/bin/app.py /app/


ENV DB_HOST=192.168.64.9
ENV DB_NAME=data
ENV DB_USER=postgres
ENV DB_PASSWORD=aquarium
ENV PORT=5000

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
