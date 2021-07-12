FROM php:7.4-apache-buster
MAINTAINER green

RUN apt-get update && apt-get install -y zip unzip git gettext curl gsfonts software-properties-common && rm -rf /var/lib/apt/lists/*

#Setting up source code
RUN git clone https://github.com/monarc-project/MonarcAppFO.git /var/lib/monarc/fo
WORKDIR /var/lib/monarc/fo
RUN ls 
RUN ls scripts
RUN mkdir -p data/cache && mkdir -p data/LazyServices/Proxy

#Install composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN mkdir ~/.ssh
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
RUN printf "\n" | pecl install imagick apcu
RUN docker-php-ext-enable imagick apcu
RUN docker-php-ext-install bcmath intl gd pdo_mysql xml 
RUN composer install -o
RUN chown -R www-data:www-data data/
RUN chmod -R 700 data/

#Conf apache
RUN a2dismod status && a2enmod ssl && a2enmod rewrite && a2enmod headers
RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY vhost.conf /etc/apache2/sites-available/monarc.conf
RUN ln -s /etc/apache2/sites-available/monarc.conf /etc/apache2/sites-enabled/monarc.conf
RUN service apache2 restart

#Setting up Back-end
RUN mkdir -p module/Monarc
RUN ln -s /var/lib/monarc/fo/vendor/monarc/core ./module/Monarc/Core
RUN ln -s /var/lib/monarc/fo/vendor/monarc/frontoffice ./module/Monarc/FrontOffice

#Setting up Front-end
RUN mkdir node_modules
RUN git clone https://github.com/monarc-project/ng-client.git node_modules/ng_client
RUN git clone https://github.com/monarc-project/ng-anr.git node_modules/ng_anr
#Setting up db connection
COPY local.php ./config/autoload/local.php

#Update monarc
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get -y install nodejs && rm -rf /var/lib/apt/lists/*
RUN npm install -g grunt-cli

EXPOSE 80

CMD ["sh", "-c", "/var/lib/monarc/fo/scripts/update-all.sh -c; apache2-foreground"]
