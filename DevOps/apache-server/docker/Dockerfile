FROM debian:latest

RUN apt-get update && apt-get install -y apache2 && apt-get install -y git

RUN git clone https://troitsart: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@github.com/troitsart/SOP.git /usr/local/git

CMD ["apache2ctl", "-D", "FOREGROUND"] 
