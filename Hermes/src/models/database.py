import psycopg2
from psycopg2 import pool
from contextlib import contextmanager

class DataBase:
    _connection_pool = None

    def __init__(self, app=None):
        if app is not None:
            self.init_app(app)

    def init_app(self, app):
        self._connection_pool = pool.SimpleConnectionPool(
            minconn=1,
            maxconn=10,
            host=app.config['DB_HOST'],
            database=app.config['DB_NAME'],
            user=app.config['DB_USER'],
            password=app.config['DB_PASSWORD']
        )

    @contextmanager
    def _get_cursor(self):
        conn = self._connection_pool.getconn()
        try:
            with conn.cursor() as cursor:
                yield cursor
                conn.commit()
        except Exception as e:
            conn.rollback()
            raise e
        finally:
            self._connection_pool.putconn(conn)

    def execute(self, query, params=None, fetch=False):
        """Универсальный метод выполнения запросов"""
        with self._get_cursor() as cursor:
            cursor.execute(query, params or ())
            
            if fetch:
                if cursor.description:  # Проверяем, есть ли результаты
                    return cursor.fetchall()
                return []
            return cursor.rowcount

    def fetch_all(self, query, params=None):
        """Выполнение SELECT запроса с возвратом всех результатов"""
        return self.execute(query, params, fetch=True)

    def close_all(self):
        if self._connection_pool:
            self._connection_pool.closeall()

    def fetch_all_json(self, query, params=None):
        """
        Выполняет запрос и возвращает результаты в формате JSON
        (список словарей, где ключи - названия колонок)
        """
        with self._get_cursor() as cursor:
            cursor.execute(query, params or ())
            
            if not cursor.description:
                return []
            
            # Получаем названия колонок
            column_names = [desc[0] for desc in cursor.description]
            
            # Получаем все строки
            rows = cursor.fetchall()
            
            # Преобразуем в список словарей
            return [dict(zip(column_names, row)) for row in rows]