# Mongoid::EmbeddedErrors

Easily bubble up errors from embedded documents in Mongoid 3 and newer.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid-embedded-errors'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-embedded-errors

## Usage

Embedded documents in Mongoid can be really useful. However, when one of those embedded documents is invalid, Mongoid spits up completely useless errors.

Let's look an example. Here we have an `Article` which `embeds_many :pages`. A `Page` `embeds_many :sections`.

```ruby
class Article
  include Mongoid::Document

  field :name, type: String
  field :summary, type: String
  validates :name, presence: true
  validates :summary, presence: true

  embeds_many :pages
end

class Page
  include Mongoid::Document

  field :title, type: String
  validates :title, presence: true

  embedded_in :article, inverse_of: :pages
  embeds_many :sections
end

class Section
  include Mongoid::Document

  field :header, type: String
  field :body, type: String
  validates :header, presence: true

  embedded_in :page, inverse_of: :sections
end
```

If we were to create an invalid `Article` with an invalid `Page` and tried to validate it the errors we see would not be very helpful:

```ruby
article = Article.new(pages: [Page.new])
article.valid? # => false

article.error.messages
# => {:name=>["can't be blank"], :summary=>["can't be blank"], :pages=>["is invalid"]}
```

Why was the `Page` invalid? Who knows! But, if we include the `Mongoid::EmbeddedErrors` module we get much better error messaging:

```ruby
class Article
  include Mongoid::Document
  include Mongoid::EmbeddedErrors

  field :name, type: String
  field :summary, type: String
  validates :name, presence: true
  validates :summary, presence: true

  embeds_many :pages
end

article = Article.new(pages: [Page.new(sections: [Section.new])])
article.valid? # => false

article.error.messages
{
  :name => ["can't be blank"],
  :summary => ["can't be blank"],
  :"pages[0].title" => ["can't be blank"],
  :"pages[0].sections[0].header" => ["can't be blank"]
}
```

Now, isn't that much nicer? Yeah, I think so to.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

[See here](https://github.com/glooko/mongoid-embedded-errors/graphs/contributors)
