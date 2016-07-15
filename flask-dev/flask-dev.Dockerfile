FROM ubuntu:trusty
MAINTAINER a@cbe-digital.de

# Install bases
RUN apt-get update && apt-get install -y \
  git curl ssh ruby nginx \
  software-properties-common \
  build-essential

# Install python
RUN apt-get install -y python-pip python-dev

# Install gunicorn
RUN pip install gunicorn

# Environment variables
ENV FLASK_USER="flask" \
  FLASK_HOME="/home/flask" \
  FLASK_PROJECT="app"

COPY assets/nginx/nginx.conf /etc/nginx/nginx.conf

# Create user
RUN adduser --disabled-login --gecos $FLASK_USER $FLASK_USER && \
  usermod -a -G sudo $FLASK_USER && \
  passwd -d $FLASK_USER

RUN chown -R $FLASK_USER:$FLASK_USER "$FLASK_HOME"

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

USER $FLASK_USER
WORKDIR "/home/$FLASK_USER/flask_app"

EXPOSE 80

ENTRYPOINT ["/sbin/entrypoint.sh"]

# docker build -f flask-dev.Dockerfile -t dk/flask .
# docker run --name=flask-app -d \
#   -v /path/to/flask/app:/home/flask/flask_app \
#   -e FLASK_PROJECT=project_name \
#   -p 8080:80 \
#   dk/flask
