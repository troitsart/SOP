FROM httpd:latest

COPY ./front/docs/ /usr/local/apache2/htdocs/docs/
COPY ./front/static/ /usr/local/apache2/htdocs/static/
COPY ./front/conf/apache/httpd.conf /usr/local/apache2/custom/

RUN sed -i '/LoadModule proxy_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule proxy_http_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule proxy_connect_module/s/^#//g' /usr/local/apache2/conf/httpd.conf

RUN sed -i 's|/var/www/docs|/usr/local/apache2/htdocs/docs|g' /usr/local/apache2/custom/httpd.conf && \
    sed -i 's|/var/www/static|/usr/local/apache2/htdocs/static|g' /usr/local/apache2/custom/httpd.conf && \
    sed -i 's|/var/log/apache2|/usr/local/apache2/logs|g' /usr/local/apache2/custom/httpd.conf && \
echo "ServerName localhost" >> /usr/local/apache2/conf/httpd.conf && \
echo "IncludeOptional custom/*.conf" >> /usr/local/apache2/conf/httpd.conf

EXPOSE 80
CMD ["httpd-foreground"]
