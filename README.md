# OmniAuth Crushpath

This gem contains the Crushpath strategy for OmniAuth 1.0.


## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth'
gem 'omniauth-crushpath'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::Crushpath` is simply a Rack middleware.
Read the OmniAuth 1.0 docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :crushpath, ENV['CRUSHPATH_KEY'], ENV['CRUSHPATH_SECRET']
end
```

In Sinatra

``` ruby
use OmniAuth::Builder do
  provider :crushpath, ENV['CRUSHPATH_KEY'], ENV['CRUSHPATH_SECRET']
end
```

The default site it will connect to is https://deals.crushpath.com but you can change it via the `:site` option
