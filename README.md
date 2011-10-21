# Widescreen
Rack based event statistic framework for any Rack app

## Requirements

Widescreen uses redis as a datastore.

Widescreen only supports redis 2.0 or greater.

If you're on OS X, Homebrew is the simplest way to install Redis:

    $ brew install redis
    $ redis-server /usr/local/etc/redis.conf

You now have a Redis daemon running on 6379.

## Setup

If you are using bundler add widescreen to your Gemfile:

    gem 'widescreen'

Then run:

    bundle install

Otherwise install the gem:

    gem install widescreen

and require it in your project:

    require 'widescreen'

## Usage

Anywhere in you code call
  
    Widescreen::Stat.add(:metric_name, 10)

to increase counter by 10 for `metric_name` metric or
    
    Widescreen::Stat.add(:metric_name)

to increase it by 1

## Web Interface

Web interface is on to-do list. It will be simple sinatra app similar to Resque web interface

## Configuration

### Redis

You may want to change the Redis host and port Wide connects to, or
set various other options at startup.

Widescreen has a `redis` setter which can be given a string or a Redis
object. This means if you're already using Redis in your app, Widescreen
can re-use the existing connection.

String: `Widescreen.redis = 'localhost:6379'`

Redis: `Widescreen.redis = $redis`

For our rails app we have a `config/initializers/widescreen.rb` file where
we load `config/widescreen.yml` by hand and set the Redis information
appropriately.

Here's our `config/widescreen.yml`:

    development: localhost:6379
    test: localhost:6379
    staging: redis1.example.com:6379
    fi: localhost:6379
    production: redis1.example.com:6379

And our initializer:

    rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
    rails_env = ENV['RAILS_ENV'] || 'development'

    widescreen_config = YAML.load_file(rails_root + '/config/widescreen.yml')
    Widescreen.redis = widescreen_config[rails_env]

## Namespaces

If you're running multiple, separate instances of widescreen you may want
to namespace the keyspaces so they do not overlap. This is not unlike
the approach taken by many memcached clients.

This feature is provided by the [redis-namespace][rs] library, which
widescreen uses by default to separate the keys it manages from other keys
in your Redis server.

Simply use the `Widescreen.redis.namespace` accessor:

    Widescreen.redis.namespace = "widescreen:blog"

We recommend sticking this in your initializer somewhere after Redis
is configured.

## Development

Source hosted at [GitHub](http://github.com/martinciu/widescreen).
Report Issues/Feature requests on [GitHub Issues](http://github.com/martinciu/widescreen/issues).

Tests can be ran with `rake spec`

### Note on Patches/Pull Requests

 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a
   future version unintentionally.
 * Commit, do not mess with rakefile, version, or history.
   (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
 * Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Marcin Ciunelis. See [LICENSE](https://github.com/martinciu/widescreen/blob/master/LICENSE) for details.
