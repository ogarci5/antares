# ALL TASKS:
# web: passenger start -p $PORT
web: rails s -p $PORT

redis: bin/perhaps_start_redis

worker: rake resque:work VERBOSE=true
delayed_worker: rake resque_delayed:work VERBOSE=true

karen: rake karen:start

log: tail -f -n 0 log/development.log
