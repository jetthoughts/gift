module CardsHelper
  def amazon_image_url item
    if item.raw.MediumImage
      return item.raw.MediumImage.URL
    end

    if item.raw.ImageSets.ImageSet.is_a? Hashie::Mash
      return item.raw.ImageSets.ImageSet.MediumImage.URL
    end

    if item.raw.ImageSets.ImageSet.is_a? Array
      return item.raw.ImageSets.ImageSet.first.MediumImage.URL
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
