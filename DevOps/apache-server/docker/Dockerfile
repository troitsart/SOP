FROM debian:latest

RUN apt-get update && apt-get install -y apache2 && apt-get install -y git

CMD ["apache2ctl", "-D", "FOREGROUND"] 
