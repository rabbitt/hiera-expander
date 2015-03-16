# hiera-expander

Hiera backend that causes each data source to be expanded into multi-level sources.

## Installation

Add this line to your application's Gemfile:

    gem 'hiera-expander'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hiera-expander

## Usage

To enable expander, simply add the following to your hiera.yaml:
```
:backends:
  - expander
```

Once enabled, it will autoamtically expand your hierarchy. Take, for example, the following hierarchy:
```
:hierarchy:
  - '%{subdomain}/%{fqdn}'
  - env/%{my_env}/%{my_type}/%{my_subtype}
  - global/%{my_type}/%{my_subtype}
  - os/%{operatingsystem}/%{operatingsystemmajrelease}
  - common
```

With hiera-expander enabled, your hierarchy would be expanded to the following:

```
:hierarchy:
  - '%{subdomain}/%{fqdn}'
  - '%{subdomain}'
  - env/%{my_env}/%{my_type}/%{my_subtype}
  - env/%{my_env}/%{my_type}
  - env/%{my_env}
  - global/%{my_type}/%{my_subtype}
  - global/%{my_type}
  - os/%{operatingsystem}/%{operatingsystemmajrelease}
  - os/%{operatingsystem}
  - common
```

Note that some of the roots (env, global and os) aren't actually expanded as well. Expanding non-interpolated roots would give you multiple "common" sources that would apply to *all* nodes - so by default, sources with non-interpolated roots aren't expanded down to the root. Should you actually desire this howerver, you can enable it by adding the following to your hiera.yaml:
```
:expander:
  :include_roots: true
```

## Contributing

1. Fork it ( https://github.com/rabbitt/hiera-expander/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
