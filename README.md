# pf2d

PixelFaucet 2D Graphics library

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     pf2d:
       github: sleepinginsomniac/pf2d
   ```

2. Run `shards install`

## Usage

```crystal
require "pf2d"

class MyView
  include PF2d::Drawable

  # Implements PF2d::Drawable
  def draw_point(x, y, color)
    # eg: @buffer[y * @width + x] == color
  end
end
```

## Contributing

1. Fork it (<https://github.com/sleepinginsomniac/pf2d/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Alex Clink](https://github.com/sleepinginsomniac) - creator and maintainer
