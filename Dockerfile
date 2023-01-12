FROM ruby:2.6-stretch

MAINTAINER Zoker <kaixuanguiqu@gmail.com>

COPY src/sources.list /etc/apt/sources.list
RUN apt-get update \
	&& apt-get install -y \
		nodejs \
		vim
ARG DATABASE_HOST="10.211.55.2" \
	DATABASE_USER="zoker" \
	DATABASE_PASSWORD="zoker" \
	DATABASE_NAME="taskover"\
	SECRET_KEY_BASE="ASECRETFORBUILD"

COPY ./ /app/taskover/
RUN mkdir -p /app/taskover/tmp/pids/ \
        && cd /app/taskover && mkdir .bundle && cp src/config /app/taskover/.bundle/ \
        && cd /app/taskover && bundle install \
        && cd /app/taskover && cp config/database.yml.example config/database.yml \
        && cd /app/taskover && cp config/puma.rb.example config/puma.rb \
        && cd /app/taskover && cp config/storage.yml.example config/storage.yml \
        && cd /app/taskover && cp config/environments/production.rb.example config/environments/production.rb \
        && cd /app/taskover && bundle exec rake db:migrate RAILS_ENV=production \
        && cd /app/taskover && bundle exec rake assets:precompile RAILS_ENV=production

COPY src/docker-entrypoint.sh /
EXPOSE 3001
ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]
