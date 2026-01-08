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

```crystal
require "pf2d"

char_grid = PF2d::Grid(Char).new(11, 11) { ' ' }
char_grid.fill_circle(PF2d::Vec[5, 5], 5, '#')

char_grid.each_row do |row|
  puts row.join
end
```

```
    ###    
  #######  
 ######### 
 ######### 
###########
###########
###########
 ######### 
 ######### 
  #######  
    ###    
```

## Implementing your own

```crystal
class View
  include PF2d::Viewable(Color)

  #...

  def get_point?(x, y) : Color?
    return nil unless in_bounds?(x, y)
    # @data[y * width + x] ... etc.
  end
end
```

```crystal
class Draw
  include PF2d::Drawable(Color)

  #...

  def draw_point(x, y, value)
    return nil unless in_bounds?(x, y)
    # @data[y * width + x] = value ... etc.
  end
end
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
