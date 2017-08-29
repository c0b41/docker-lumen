FROM php:5.6-apache
MAINTAINER Ayhan Kuru <ayhankuru@yandex.com.tr>

RUN apt-get update && apt-get -y install git curl php5-mcrypt php5-json && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN /usr/sbin/a2enmod rewrite

ADD app.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite app

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir -p /var/www/app && cd /var/www/app && /usr/local/bin/composer install
RUN /bin/chown www-data:www-data -R /var/www/app/storage /var/www/app/bootstrap/cache

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]