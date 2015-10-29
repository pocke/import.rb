[![Gem Version](https://badge.fury.io/rb/import.rb.svg)](https://badge.fury.io/rb/import.rb)

# import.rb

Instead of `Kernel.require`.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'import.rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install import.rb

## Usage

- cat.rb

```ruby
class Cat
  def meow
    puts 'meow meow'
  end
end
```

- main.rb

```ruby
require 'import'
cat = import('./cat')::Cat
cat.new.meow # => meow meow

# Cat  # => uninitialized constant Cat (NameError)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/import.rb .


## Reference

- [http://pocke.hatenablog.com/entry/2015/10/28/154214:title] (Japanese Blog)
