require 'pry'

module BaseItem
  attr_accessor :item
  attr_reader :sell_in, :quality

  def initialize(item)
    @item = item
    @sell_in = item.sell_in
    @quality = item.quality
  end
end

class Normal
  include BaseItem

  def update
    @item.sell_in -= 1
    return if zero_quality?

    @item.quality -= 1
    @item.quality -= 1 if @sell_in == 0 or after_sell_date?
  end

  private def zero_quality?
    @quality.zero?
  end

  private def after_sell_date?
    @sell_in == -10
  end
end

class AgedBrie
  include BaseItem

  def update
    @item.sell_in -= 1
    return if maxium_quality?
    @item.quality += 1
    @item.quality += 1 if @sell_in.zero? and near_max_quality?
    @item.quality += 1 if after_sell_date?
  end

  private def maxium_quality?
    @quality == 50
  end

  private def near_max_quality?
    @quality < 49
  end

  private def after_sell_date?
    @sell_in == -10
  end
end

def update_quality(items)
  items.each do |item|
    case item.name
    when "NORMAL ITEM" then Normal
    when "Aged Brie" then AgedBrie
    end.new(item).update
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

