FROM postgres:15-alpine

# Установка переменных окружения
ENV POSTGRES_USER=troits \
    POSTGRES_PASSWORD=aquarium \
    POSTGRES_DB=data

# Копируем скрипт инициализации
COPY database/init.sql /docker-entrypoint-initdb.d/

# Даем права на выполнение скрипта
RUN chmod a+r /docker-entrypoint-initdb.d/init.sql
