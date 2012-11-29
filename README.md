# PrivateAttr

Perhaps it's just personal preference, but I don't like to use instance
variables througout my Ruby classes. At the same time, I don't
necessarily want public attribute readers and writers. This causes me to
tend to use something like the following:

```ruby
class Foo

  def initialize bar
    self.bar = bar
  end

  def use_bar
    bar
  end

  private

  attr_accessor :bar
end
```

But, I really like to declare my attribute readers and writers near the
top of my classes, which means I sometimes use something like:

```ruby
class Bar

  attr_accessor :foo
  private :foo, :foo=

  def initialize foo
    self.foo = foo
  end
end
```

This library is meant to be a convenient solution to that verbosity.

## Installation

Add this line to your application's Gemfile:

    gem 'private_attr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install private_attr

## Usage

```ruby
class Bar
  extend PrivateAttr

  private_attr_accessor :foo
  private_attr_reader :baz
  private_attr_writer :bat

  def initialize foo
    self.foo = foo
  end
end
```

It even does protected attributes:

```ruby
class Bar
  extend PrivateAttr

  protected_attr_accessor :foo
  protected_attr_reader :baz
  protected_attr_writer :bat

  def initialize foo
    self.foo = foo
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
