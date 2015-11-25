# PivotalBugsnacker

Script for adding useful bugsnag information to pivotal tracker bugs that are linked to from bugsnag.

For example, a pivotal tracker item with the title:

Failed to create comment because activity_log_iteration_id of 0 was not found
Will be updated to say: [users:2,last_received:11/19/2015 11:57AM,occurrences:4] Failed to create comment because activity_log_iteration_id of 0 was not found

Where users is the number of users, last_received is the last time the error was seen, and occurences is the number of times the bug happened.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pivotal_bugsnacker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pivotal_bugsnacker

## Usage
In order to use the script the following environment variables must be set:

TRACKER_TOKEN - Your pivotal tracker api key.
BUGSNAG_API_KEY - Your bugsnag api key.
REDIS_URL - Your redis url.  
If REDIS_URL is missing, we default to localhost and the default redis port.

Redis is used for keeping track of what bugsnag events have already been seen. Used for speeding up the script by cutting down on the number of calls to the pivotal api.

Then simply execte the script:

    pivotal_bugsnacker

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pivotal_bugsnacker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
