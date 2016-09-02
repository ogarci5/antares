# ALL TASKS:
# web: passenger start -p $PORT
web: bundle exec rails s -p $PORT

redis: bin/perhaps_start_redis

worker: bundle exec rake resque:work VERBOSE=true
delayed_worker: bundle exec rake resque_delayed:work VERBOSE=true

karen: bundle exec rake karen:start

log: tail -f -n 0 log/development.log
