from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

# Конфигурация БД из переменных окружения
DB_CONFIG = {
    "host": os.getenv("DB_HOST", "db"),
    "database": os.getenv("DB_NAME", "mydb"),
    "user": os.getenv("DB_USER", "myuser"),
    "password": os.getenv("DB_PASSWORD", "mypassword")
}

def get_db_connection():
    """Подключение к PostgreSQL"""
    conn = psycopg2.connect(**DB_CONFIG)
    return conn

@app.route("/data", methods=["GET"])
def get_data():
    """Получение данных из таблицы your_table"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM passengers.passengers;")
        data = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify({"data": data})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
