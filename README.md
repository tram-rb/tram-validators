# Evil::Validators

Collection of ActiveModel validators for rails projects

## Installation

```ruby
gem "evil-validators"
```

## Usage

Below is a short review of available validators. Read the [specs][specs] for more details:

[specs]: ./

### Size Validator

Compares size of array to given value or another attribute

```ruby
# record.names.size < 6
# adds error under key `size_less_than`
validates :names, size: { less_than: 6 }

# record.values.size == record.parent&.names&.size
# adds error under key `size_equal_to_parent_names_size`
validates :values, size: { equal_to: "parent.names.size" }
```

All keys from standard rails [numericality validator][numericality] are supported.
