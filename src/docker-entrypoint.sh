#!/bin/bash
cd /app/taskover && bundle exec rake db:migrate RAILS_ENV=production
cd /app/taskover && bundle exec rake init RAILS_ENV=production
cd /app/taskover && bundle exec puma -e production &
tail -f /app/taskover/log/*
