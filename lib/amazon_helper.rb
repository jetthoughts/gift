module AmazonHelper
  def amazon_images_list item
    sets = item.raw.ImageSets.ImageSet
    if sets.is_a? Array
      sets.map do |set|
        set.LargeImage.URL
      end
    else
      [sets.LargeImage.URL]
    end
  end

  def amazon_details_url item
    item.raw.DetailPageURL
  end

  def amazon_product_group item
    item.raw.ItemAttributes.ProductGroup 
  end

  def amazon_image_url item
    if item.raw.LargeImage
      return item.raw.LargeImage.URL
    end

    if item.raw.ImageSets.ImageSet.is_a? Hashie::Mash
      return item.raw.ImageSets.ImageSet.LargeImage.URL
    end

    if item.raw.ImageSets.ImageSet.is_a? Array
      return item.raw.ImageSets.ImageSet.first.LargeImage.URL
    end

    item.image_url
  end

  def amazon_formatted_price item
    price = amazon_price item
    return price.FormattedPrice if price
    'Not setted'
  end

  def amazon_amount item
    price = amazon_price item
    return price.Amount if price
    'Not setted'
  end

  def amazon_price item
    if item.raw.ItemAttributes.ListPrice
      return item.raw.ItemAttributes.ListPrice
    end

    if item.raw.OfferSummary!.LowestNewPrice
      return item.raw.OfferSummary.LowestNewPrice
    end

    nil
  end

end
