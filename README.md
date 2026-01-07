# PF2d

PF2d is a 2d drawing library that provides a set of structs and methods for 2d drawing operations.
PF2d was extracted from [PixelFaucet](https://github.com/sleepinginsomniac/pixelfaucet).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     pf2d:
       github: sleepinginsomniac/pf2d
   ```

2. Run `shards install`

## Usage

PF2d doesn't make assumptions about the underlying data structure,
so you must tell it how to draw a point. In this case it's a grid of RGB values,
but it could just as well be a grid of characters.

```crystal
require "pf2d"

struct Color
  property r : UInt8, g : UInt8, b : UInt8

  def initialize(@r, @g, @b)
  end
end

class MyCanvas
  include PF2d::Canvas(Color) # Include the drawable module

  # Implement the required methods for PF2d::Canvas
  getter width : Int32, height : Int32

  def initialize(@width, @height)
    # Store the data somehow
    @buffer = Slice(Color).new(@width * @height)
  end

  # Required by PF::Canvas for canvas to canvas operations
  def blend(src, dst) : Color
    dst # Here, just choose the other color
  end

  def index(x, y)
    y * width + x
  end

  # Implement the required method PF2d::Drawable
  def draw_point(x, y, value)
    return nil unless in_bounds?(x, y) # Provided by PF::Canvas
    @buffer[index(x, y)] == color
  end

  # Implement the required method PF2d::Viewable
  def get_point?(x, y, value)
    return nil unless in_bounds?(x, y) # Provided by PF::Canvas
    @buffer[index(x, y)]
  end
end

MyCanvas[11, 11].fill_circle(PF::Vec[5, 5], 5, Color.new(0, 255, 0))
```

## Caveats

- Drawing operations don't anti-alias

## Contributing

1. Fork it (<https://github.com/sleepinginsomniac/pf2d/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Alex Clink](https://github.com/sleepinginsomniac) - creator and maintainer
