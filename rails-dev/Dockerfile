FROM sameersbn/ubuntu:14.04.20160422
MAINTAINER a@cbe-digital.de

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E1DD270288B4E6030699E45FA1715D88E1DF1F24 \
  && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 \
  && echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor logrotate nodejs sudo \
      libsqlite3-dev nginx mysql-client postgresql-client \
      imagemagick git bzr darcs rsync ruby2.3 locales \
      gcc g++ make patch pkg-config gettext-base ruby2.3-dev libc6-dev zlib1g-dev libxml2-dev \
      libpq5 libpq-dev libyaml-0-2 libcurl3 libssl1.0.0 libmysqlclient18 \
      libxslt1.1 libffi6 zlib1g gsfonts ssh \
  && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
  && gem install --no-document bundler thin

ENV RAILS_USER="rails" \
    RAILS_HOME="/home/rails" \
    RAILS_ENV=production \
    RAILS_PROJECT="app" \
    RAILS_START_SCRIPT="rails"

COPY assets/nginx/nginx.conf /etc/nginx/nginx.conf

RUN adduser --disabled-login --gecos 'rails' $RAILS_USER && \
  passwd -d $RAILS_USER && \
  usermod -a -G sudo $RAILS_USER

RUN chown -R "$RAILS_USER:$RAILS_USER" "$RAILS_HOME"

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80
EXPOSE 22

USER $RAILS_USER

WORKDIR "$RAILS_HOME/app"
ENTRYPOINT ["/sbin/entrypoint.sh"]

# docker build -f Dockerfile -t dk/rails-dev:2.3 .
###
# Example
# docker run -d --name rails-app-db \
#     -e POSTGRES_PASSWORD=mysecretpassword \
#     -v /var/www/rails/db:/var/lib/postgresql/data \
#     --restart=always \
#     postgres

# docker run -d --name=rails-app \
#     --link rails-app-db:db \
#     -v /path/to/rails/app:/home/rails/app \
#     -e RAILS_ENV=development \
#     -p 8080:80 \
#     dk/rails-dev:2.3

