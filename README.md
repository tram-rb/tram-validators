# Evil::Validators

Collection of ActiveModel validators for rails projects, designed to support policy objects, forms, and other types of standalone validators, that could reuse each other.

## Installation

```ruby
gem "evil-validators"
```

## Usage

Below is a short review of available validators. Read the [specs][specs] for more details:

[specs]: ./

### Contract Validator

Checks that a value satisfies a contract, represented by a standalone validator (policy object).
It applies policy validator, and collects its messages under corresponding keys.

```ruby
class PolicyObject < SimpleDelegator
  include ActiveModel::Validations
  validates :bar, presence: true
end

# PolicyObject.new(record.foo).valid? == true
# collects original error messages from policy under the key `foo`
validates :foo, contract: { policy: PolicyObject }

# collects the same messages from policy under their original keys (`bar`)
validates :foo, contract: { policy: PolicyObject, original_keys: true }

# collects the same messages from policy under nested keys (`foo[bar]`)
validates :foo, contract: { policy: PolicyObject, nested_keys: true }
```

### Validity Validator

Checks that a value is valid per se, and collects original error messages under corresponding keys.
Uses the same syntax for keys as the Contract Validator above.

```ruby
# record.foo.valid? == true
# collects original error messages under the key `foo`
validates :foo, validity: true

# collects the same messages from policy under their original keys (`bar`)
validates :foo, validity: { original_keys: true }

# collects the same messages from policy under nested keys (`foo[bar]`)
validates :foo, validity: { nested_keys: true }
```

### Size Validator

Compares size of array to given value or another attribute

```ruby
# record.names.size < 6
# adds error named `size_less_than` under the key `names`
validates :names, size: { less_than: 6 }

# record.values.size == record.parent&.names&.size
# adds error named `size_equal_to_parent_names_size` under the key `names`
validates :values, size: { equal_to: "parent.names.size" }
```

All keys from standard rails [numericality validator][numericality] are supported.
