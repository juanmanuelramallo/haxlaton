# Haxlaton

[![CI](https://github.com/juanmanuelramallo/haxlaton/actions/workflows/ci.yml/badge.svg)](https://github.com/juanmanuelramallo/haxlaton/actions/workflows/ci.yml)
[![Haxball client](https://github.com/juanmanuelramallo/haxlaton/actions/workflows/haxball_client.yml/badge.svg)](https://github.com/juanmanuelramallo/haxlaton/actions/workflows/haxball_client.yml)

A server where the results of www.haxball.com matches will be stored. In Haxball you should configure a bot that will communicate with this server (check https://github.com/juanmanuelramallo/haxlaton/tree/master/lib/haxball_client for further references about the bot code)

## Setup

### ENV vars
Create a file `.env` and add `HOST_NAME=www.haxball.com` entry.

### Install
Execute the next commands:
```sh
bundle install
yarn install
bundle exec rake assets:precompile
bundle exec rails db:setup
bundle exec rails db:migrate
```

## Run the server
Now you're ready to get the server up and running
```sh
bundle exec rails s
```

Enjoy!
