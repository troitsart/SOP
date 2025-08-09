FROM python:3.9-slim

WORKDIR /app

COPY hermes/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY hermes/ .

ENV PYTHONPATH=/app

ENV DB_HOST=database
ENV DB_NAME=data
ENV DB_USER=troits
ENV DB_PASSWORD=aquarium
ENV PORT=5000

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:create_app()"]
