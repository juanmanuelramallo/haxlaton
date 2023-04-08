release: bundle exec rails db:migrate
web: bundle exec puma -C config/puma.rb
worker: RAILS_MAX_THREADS=${SIDEKIQ_WORKER_RAILS_MAX_THREADS:-10} bundle exec sidekiq -q default -c ${SIDEKIQ_WORKER_CONCURRENCY:-10}
