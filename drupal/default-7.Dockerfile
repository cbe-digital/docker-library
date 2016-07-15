# from https://www.drupal.org/requirements/php#drupalversions
FROM ubuntu:trusty

# install bases
RUN apt-get update && apt-get install -y \
  git curl ssh ruby \
  apache2 apache2-utils mysql-client \
  software-properties-common

# install php
RUN apt-get install -y language-pack-en-base && \
  LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php5-5.6 -y && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y php5 \
  php5-curl php5-dev php5-gd php5-mysql php5-pgsql \
  php5-sqlite php5-apcu php5-intl php5-imap \
  php5-mcrypt

# install additional tools
RUN apt-get install -y \
  nodejs \
  npm \
  zip && \
  ln -s /usr/bin/nodejs /usr/bin/node

# Install wkhtmltopdf and dependencies
RUN \
  cd /tmp && \
  wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2/wkhtmltox-0.12.2_linux-trusty-amd64.deb && \
  apt-get install -y fontconfig libxrender1 xfonts-base xfonts-75dpi && \
  dpkg -i wkhtmltox-*.deb && \
  rm -rf wkhtmltox-*

# configure apache
#mods
RUN a2enmod auth_basic rewrite headers

#config
ENV DRUPAL_USER="drupal" \
  DRUPAL_HOME="/home/drupal"

COPY assets/apache2.conf /etc/apache2/apache2.conf
COPY assets/php.ini /etc/php5/apache2/php.ini
COPY httpd-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/httpd-foreground

# create use
RUN adduser --disabled-login --gecos $DRUPAL_USER $DRUPAL_USER && \
  usermod -a -G sudo $DRUPAL_USER && \
  passwd -d $DRUPAL_USER

# install additional tools
# sass
RUN gem install sass

# gulp
RUN npm install -g gulp

# composer
RUN  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer
# drush
RUN php -r "readfile('http://files.drush.org/drush.phar');" > drush.phar && \
  chmod +x drush.phar && \
  mv drush.phar /usr/local/bin/drush
# install kraftwagen
RUN mkdir -p $DRUPAL_HOME/.drush && \
  git clone "git://github.com/kraftwagen/kraftwagen.git" $DRUPAL_HOME/.drush/kraftwagen && \
  git clone "git://github.com/RobinCee/drush_language.git" $DRUPAL_HOME/.drush/drush_language && \
  drush cc drush

# copy gitconfig
COPY assets/.gitconfig $DRUPAL_HOME/.gitconfig

RUN chown -R $DRUPAL_USER:$DRUPAL_USER "$DRUPAL_HOME" && \
  usermod -aG www-data $DRUPAL_USER && \
  ln -s /var/www/html $DRUPAL_HOME/www

USER $DRUPAL_USER
WORKDIR "/home/$DRUPAL_USER/www"

EXPOSE 80
ENTRYPOINT ["httpd-foreground"]

# docker build -f default-7.Dockerfile -t dk/dev-drupal:7.x .
# docker run --name drupal-db -d \
#   -e MYSQL_ROOT_PASSWORD=my-secret-pw \
#   -e MYSQL_DATABASE=drupal \
#   -e MYSQL_USER=drupal_user \
#   -e MYSQL_PASSWORD=my-secret-pw \
#   -e TERM=dumb \
# #   mariadb
# docker run --name=drupal -d \
#   --link drupal-db:db \
#   -p 8080:80 \
#   -v /path/to/drupal:/var/www/html \
#   dk/dev-drupal:7.x
# docker run -it --rm --entrypoint=bash dk/dev-drupal:7.x
