# LcClassification

LcClassification is a simple lookup gem for returning categories from Library of
Congress classification strings. The basic format is `AA###.####` where a one or
two letter prefix determines the broad category and numbers break it out into
more specific subcategories.

The categories in this gem are parsed from a text file originally found here: [http://archive.org/stream/LcClassificationA-z/lc_class.txt].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lc_classification'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lc_classification

## Usage

Because the gem reads a text file on initialization it is recommended that it
be instantiated once (perhaps wrapped as a Singleton) if it is going to be used
multiple time.

```ruby

# reads copy of file in data/library-of-congress-classification.txt by default
lookup = LcClassification::Lookup.new
node = lookup.find('AC903')
node.description #> "Pamphlet Collections"
node.parent.description #> "Collections of monographs, essays, etc."
node.parent.parent.description #> "Collections.  Series.  Collected works"

node.description.path #> [
#> "AC",
#> "Collections.  Series.  Collected works",
#> "Collections of monographs, essays, etc.",  
#> "Pamphlet Collections"  
#> ]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lc_classification.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
