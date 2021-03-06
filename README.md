# Tram::Validators

Collection of ActiveModel validators for rails projects with focus on composition of standalone policy objects.

<a href="https://evilmartians.com/">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54"></a>

[![Gem Version][gem-badger]][gem]
[![Build Status][travis-badger]][travis]
[![Dependency Status][gemnasium-badger]][gemnasium]
[![Code Climate][codeclimate-badger]][codeclimate]

## Installation

```ruby
gem "tram-validators"
```

## Usage

Below is a short review of available validators. Read the [specs][specs] for more details:

### Contract Validator

Checks that a value satisfies a contract, represented by a standalone validator (policy object).
It applies policy validator, and collects its messages under corresponding keys.

```ruby
require "tram-validators" # defines `validity` validator

class SpecificPolicy < SimpleDelegator
  include ActiveModel::Validations
  validates :bar, presence: true
  validates :itself, validity: true # validates wrapped object per se
end

# PolicyObject.new(record.foo).valid? == true
# adds message with i18 translation `foo.contract_specific_policy`
validates :foo, contract: { policy: SpecificPolicy }

# collects messages from policy under their original keys (`bar`)
validates :foo, contract: { policy: PolicyObject, original_keys: true }

# collects messages from policy under nested keys (`foo[bar]`)
validates :foo, contract: { policy: PolicyObject, nested_keys: true }
```

When you use `:nested_keys`, the keys `:base` and `:itself` will be excluded from chain of nesting.
That's why when `PolicyObject` is invalid at `:itself`, the last definition will collect error under the key `foo`, not the `foo[itself]`.

### Validity Validator

Checks that an attribute is valid per se.
It collects original error messages under corresponding keys.

```ruby
# record.foo.valid? == true
# adds message with i18 translation `foo.valid`
validates :foo, validity: true

# collects messages from invalid value under their original keys (`bar`)
validates :foo, validity: { original_keys: true }

# collects messages from invalid value under nested keys (`foo[bar]`)
validates :foo, validity: { nested_keys: true }
```

### Each Validator

Applies validation rule to every element of the collection (that responds to `to_a`).

```ruby
# Checks that every element of record.list is present
# collects original errors under keys `list[i]` (i for index of invalid item)
validates :list, each: { presence: true }
```

### Outcome Validator

Validates value by checking another method depending on it.

```ruby
# Validates `user_id` by checking that `user.role` (depending on user_id) is set
# adds error `user_role_presence` to the original attribute  `user_id`
validates :user_id, outcome: { value: "user.role", presence: true }
```

This technics is useful in form objects where you should attach errors to the original fields accessible to the user.

### Consistency Validator

Compares a value of some attribute to a value of another attribute or method chain.
Supports all keys from the standard rails [numericality validator][numericality].

```ruby
# record.foo < record.bar.baz
# adds error named `less_than_bar_baz` under the key `foo`
validates :foo, consistency: { less_than: "bar.baz" }
```

### Size Validator

Compares size of array to given value or another attribute.
Supports all keys from the standard rails [numericality validator][numericality].

```ruby
# record.names.size < 6
# adds error named `size_less_than` under the key `names`
validates :names, size: { less_than: 6 }

# record.values.size == record.parent&.names&.size
# adds error named `size_equal_to_parent_names_size` under the key `names`
validates :values, size: { equal_to: "parent.names.size" }
```

### Reference Validator

This is an AR-dependent validator, that checks an instance can be extracted from database by given key.

```ruby
# Checks that User.find_by(record.user_key).present?
validates :user_key, reference: { model: User, find_by: :key }
```

Like the outcome validator above, it can be useful for validation of form objects.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[specs]: ./spec/tram-validators
[numericality]: http://guides.rubyonrails.org/active_record_validations.html#numericality
[codeclimate-badger]: https://img.shields.io/codeclimate/github/tram-rb/tram-validators.svg?style=flat
[codeclimate]: https://codeclimate.com/github/tram-rb/tram-validators
[gem-badger]: https://img.shields.io/gem/v/tram-validators.svg?style=flat
[gem]: https://rubygems.org/gems/tram-validators
[gemnasium-badger]: https://img.shields.io/gemnasium/tram-rb/tram-validators.svg?style=flat
[gemnasium]: https://gemnasium.com/tram-rb/tram-validators
[travis-badger]: https://img.shields.io/travis/tram-rb/tram-validators/master.svg?style=flat
[travis]: https://travis-ci.org/tram-rb/tram-validators
