# Sidekiq::Tip

[![Build Status](https://travis-ci.org/zzet/sidekiq-tip.svg)](https://travis-ci.org/zzet/sidekiq-tip) [![Coverage Status](https://coveralls.io/repos/zzet/sidekiq-tip/badge.svg?branch=master&service=github)](https://coveralls.io/github/zzet/sidekiq-tip?branch=master)

Perform sidekiq jobs in time interval

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-tip'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install sidekiq-tip
```

## Usage

```ruby
class SomeJob
  include Sidekiq::Worker
  # [0, 0, 0] == [hour, min, sec]
  sidekiq_options start_at: [0, 0, 0], finish_at: [10, 0, 0]

  def perform
    # ...
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sidekiq-tip/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
