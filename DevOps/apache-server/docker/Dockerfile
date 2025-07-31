FROM debian:latest

RUN apt-get update && apt-get install -y apache2 && apt-get install -y git

RUN mkdir /opt/repos

RUN git clone https://troitsart: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@github.com/troitsart/SOP.git /opt/repos

RUN ln -sT /opt/repos/front/docs /var/www/docs && ln -sT /opt/repos/front/conf/apache /etc/apache2/custom

RUN echo "IncludeOptional custom/*.conf" >> /etc/apache2/apache2.conf

CMD apache2ctl -D FOREGROUND & /opt/repos/DevOps/auto-pull.sh
