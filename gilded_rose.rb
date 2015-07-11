def update_quality(items)
  items = ItemsQuality.new(items)
  items.update
end

class StandardQuality

  attr_accessor :item

  def initialize(item)
    self.item = item
  end

  def update
    update_quality
    update_sell_in
    validate_minimum_value
    validate_maximun_value
    self.item
  end

  def update_quality
    self.item.sell_in <= 0 ? decrease_quality(2) : decrease_quality(1)
  end

  def update_sell_in
    self.item.sell_in -= 1
  end

  private

    def increase_quality(amount)
      self.item.quality += amount
    end

    def decrease_quality(amount)
      increase_quality(-amount)
    end

    def validate_minimum_value
      self.item.quality = 0 if self.item.quality < 0
    end

    def validate_maximun_value
      self.item.quality = 50 if self.item.quality > 50
    end

end


class SulfurasQuality < StandardQuality
  def update
    validate_maximun_value
    self.item
  end

  private

    def validate_maximun_value
      self.item.quality = 80
    end
end


class AgedQuality < StandardQuality
  def update_quality
    self.item.sell_in <= 0 ? increase_quality(2) : increase_quality(1)
  end
end


class BackstageQuality < StandardQuality
  def update_quality
    if self.item.sell_in > 10
      increase_quality(1)
    elsif self.item.sell_in > 5
      increase_quality(2)
    elsif self.item.sell_in > 0
      increase_quality(3)
    else
      self.item.quality = 0
    end
  end
end


class ConjuredQuality < StandardQuality
  def update_quality
    self.item.sell_in <= 0 ? decrease_quality(4) : decrease_quality(2)
  end
end


class ItemsQuality

  attr_accessor :items

  def initialize(items)
    self.items = items
  end

  def update
    self.items.each {|item| update_item(item)}
  end

  private

    def update_item(item)
      quality_object = quality_type(item)
      quality_object.update
    end

    def quality_type(item)
      case item.name
      when /^Sulfuras/
        SulfurasQuality.new(item)
      when /^Aged Brie$/
        AgedQuality.new(item)
      when /^Backstage passes/
        BackstageQuality.new(item)
      when /^Conjured /
        ConjuredQuality.new(item)
      else
        StandardQuality.new(item)
      end
    end

end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]
