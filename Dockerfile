FROM php:8.2.0-apache

# user, group
ARG USERNAME=app
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Apache2
# DocumentRoot を環境変数で設定可能化 (また、rewrite 有効化も実施)
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e "s!/var/www/html!\${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf \
  && sed -ri -e "s!/var/www/!\${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
COPY ./etc/apache2/sites-available/001-my.conf /etc/apache2/sites-available/001-my.conf
RUN a2dissite 000-default \
  && a2ensite 001-my \
  && a2enmod rewrite
# SSL ファイルを環境変数で設定可能化
ENV APACHE_SSL_CERTIFICATE_FILE /etc/ssl/certs/ssl-cert-snakeoil.pem
ENV APACHE_SSL_CERTIFICATE_KEY_FILE /etc/ssl/private/ssl-cert-snakeoil.key
RUN sed -ri -e "s!/etc/ssl/certs/ssl-cert-snakeoil.pem!\${APACHE_SSL_CERTIFICATE_FILE}!g" /etc/apache2/sites-available/*.conf \
  && sed -ri -e "s!/etc/ssl/private/ssl-cert-snakeoil.key!\${APACHE_SSL_CERTIFICATE_KEY_FILE}!g" /etc/apache2/apache2.conf /etc/apache2/sites-available/*.conf
RUN a2ensite default-ssl.conf \
  && a2enmod ssl

USER ${USERNAME}
