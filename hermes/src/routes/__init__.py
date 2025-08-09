from flask import Blueprint
from .passengers import passengers_bp

def init_routes(app):
    """
    Инициализирует и регистрирует все Blueprint'ы приложения
    
    Args:
        app: Flask-приложение
    """
    # Регистрация Blueprint'ов
    app.register_blueprint(passengers_bp, url_prefix='/api/passengers')
    
    # Можно добавить базовый маршрут для проверки работы
    @app.route('/')
    def health_check():
        return {'status': 'ok', 'message': 'Hermes API is running'}