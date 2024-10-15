# TODO: modularize
force_quit_rails() {
  ps -ef | grep "rails" | grep -v grep | awk '{print $2}' | xargs kill -2
}

force_quit_sidekiq() {
  ps -ef | grep "sidekiq" | grep -v grep | awk '{print $2}' | xargs kill -2
}
