# taxi

A fun compiled language

## Installation

```bash
shards build --release
```

## Example

```tx

fun main() void {
	print_str("Hello, world\n");
    local my_var integer = 25;
    print_int(my_var);
}
# ==> Hello, world
# ==> 25

```

## Contributing

1. Fork it (<https://github.com/PacketSender642/taxi/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Voxaloo](https://github.com/PacketSender642) - creator and maintainer
