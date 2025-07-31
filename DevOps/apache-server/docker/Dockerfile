FROM debian:latest

RUN apt-get update && apt-get install -y apache2 && apt-get install -y git

RUN mkdir /opt/repos

RUN git clone https://troitsart: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@github.com/troitsart/SOP.git /opt/repos

RUN ln -sT /opt/repos/SOP/front/docs /var/www/docs

CMD ["apache2ctl", "-D", "FOREGROUND"] 
