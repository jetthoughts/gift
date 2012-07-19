module Sampledata
  class Data

    attr_accessor :products

    def populate
      load_shipment_carriers
      load_shop
      load_shipping_methods
      load_product_group_for_price
      load_product_group_for_category

      load_tag_watch
      load_iphone_cover
      load_turquoise_bracelet
      load_bag
      load_tajmahal
      load_chronograph_watch
      load_mangoes
      load_bangles
      load_shoes
    end

    private

    def load_shipment_carriers
      %w(UPS USPS Fedex).each { |carrier| ShipmentCarrier.create!(name: carrier) }
    end

    def load_shop
      Shop.create!( name:           'nimbleShop',
                   phone_number:    '800-456-7890',
                   twitter_handle:  '@nimbleshop',
                   from_email:      'support@nimbleshop.com',
                   tax_percentage: 1.23,
                   google_analytics_tracking_id: Nimbleshop.config.google_analytics_tracking_id,
                   facebook_url:    'http://www.facebook.com/pages/NimbleSHOP/119319381517845')
    end

    def handle_pictures_for_product(product, dirname)
      p = Pathname.new(File.expand_path('../pictures', __FILE__))
      pictures = Dir.glob(p.join(dirname, '*'))

      pictures.sort.each do |filename|
        attach_picture( filename, product)
      end
    end

    def attach_picture(filename_with_extension, product)
      path = Rails.root.join('lib', 'sampledata', 'pictures', filename_with_extension)
      product.attach_picture(filename_with_extension, path)
    end

    def load_product_group_for_price
      pg_lt_50 = ProductGroup.create!(name: '< $50')
      pg_lt_50.product_group_conditions.create(name: 'price', operator: 'lt', value: 50)
      pg_between_50_100 = ProductGroup.create!(name: '$50 - $100')
      pg_between_50_100.product_group_conditions.create(name: 'price', operator: 'gteq', value: 50)
      pg_between_50_100.product_group_conditions.create(name: 'price', operator: 'lteq', value: 100)
      pg_gt_100 = ProductGroup.create!(name: '> $100')
      pg_gt_100.product_group_conditions.create(name: 'price', operator: 'gt', value: 100)

      link_group = LinkGroup.create!(name: 'Shop by price')
      Navigation.create!(link_group: link_group, product_group: pg_lt_50)
      Navigation.create!(link_group: link_group, product_group: pg_between_50_100)
      Navigation.create!(link_group: link_group, product_group: pg_gt_100)
    end

    def load_product_group_for_category
      cf = CustomField.create!(name: 'category', field_type: 'text')

      pg_food = ProductGroup.create!(name: 'Food')
      pg_food.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'food')

      pg_toy = ProductGroup.create!(name: 'Toy')
      pg_toy.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'toy')

      pg_art = ProductGroup.create!(name:  'Art')
      pg_art.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'art')

      pg_fashion = ProductGroup.create!(name: 'Fashion')
      pg_fashion.product_group_conditions.create(name: cf.id, operator: 'eq', value: 'fashion')

      link_group = LinkGroup.create!(name: 'Shop by category')
      link_group.navigations.create(product_group: pg_art)
      link_group.navigations.create(product_group: pg_food)
      link_group.navigations.create(product_group: pg_fashion)
    end

    def load_shipping_methods
      sz = CountryShippingZone.create!(country_code: 'US')
      ShippingMethod.create!(name: 'Ground shipping', base_price: 10, shipping_zone_id: sz.id,
                             minimum_order_amount: 0, maximum_order_amount: 999999)

      ShippingMethod.create!(name: 'Express shipping', base_price: 30, shipping_zone_id: sz.id,
                             minimum_order_amount: 10, maximum_order_amount: 999999)
    end

    def load_tajmahal
      print '.'
      desc = %q{
        Year of construction: 1631
        Completed in: 1653
        Time taken: 22 years
        Built by: Shah Jahan
        Dedicated to: Mumtaz Mahal (Arjumand Bano Begum), the wife of Shah Jahan
        Location: Agra (Uttar Pradesh), India
        Building type: Islamic tomb
        Architecture: Mughal (Combination of Persian, Islamic and Indian architecture style)
        Architect: Ustad Ahmad Lahauri
        Cost of construction: 32 crore rupees
        Number of workers: 20,000
        Highlights: One of the Seven Wonders of the World; A UNESCO World Heritage Site

        Facts do not capture what Tajmahal is.
      }
      product = Product.create!( title: "Beautiful portrait of Tajmahal", price: 19, description: desc)
      handle_pictures_for_product(product, "product1")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'art')
    end

    def load_chronograph_watch
      print '.'
      desc = %q{
        Chronograph sport watch from Guess

        Chronograph: Stopwatch function, 24 Hour/Intl. time
        43/43/13 
        Brushed + Polished Ionic Black case
        Red + Black dial
        Brushed + Polished Ionic Black Steel bracelet 
        100 M/330 FT Water resistant
      }
      product = Product.create!( title: "chronograph sport watch from Guess", price: 219, description: desc)
      handle_pictures_for_product(product, "product2")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'fashion')
    end

    def load_turquoise_bracelet
      print '.'
      desc = %q{
        Simple, modern, stylish, easy to wear bracelet ! 

        For a scale reference please see the photos with the bracelet worn.

        For a custom color bracelet send me a message and I will see what colors are available for your bracelet.

        The strap of the bracelet can also be customized in any color you would like. 

        All items come to you beautifully packaged and ready for gift giving.

        Note that real colors may slightly differ from their appearance on your display.
        }
      product = Product.create!( title: "Turquoise bracelet", price: 89, description: desc)
      handle_pictures_for_product(product, "product3")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'fashion')
    end

    def load_mangoes
      print '.'
      desc = %q{
        The mango is the national fruit of India and Pakistan. It is also the national fruit in the Philippines. The mango tree is the national tree of Bangladesh.

        Mango leaves are used to decorate archways and doors in Indian houses and during weddings and celebrations.
      }
      product = Product.create!( title: "A basket of Indian mangoes", price: 17, description: desc)
      handle_pictures_for_product(product, "product4")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'food')
    end

    def load_bag
      print '.'
      desc = %q{
        Stylish bag in indigo color. How could you say no to this.

        It is just the perfect size also. It has enough space to carry ipad, magazine, cosmetic stuff and othe accessories.

        Length: 32cm(12.60 inches)
        Width: 19cm(7.48 inches)
      }
      product = Product.create!( title: "A simple and elegant bag", price: 107, description: desc)
      handle_pictures_for_product(product, "product5")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'fashion')
    end

    def load_bangles
      print '.'
      desc = %q{
        Bangles are part of traditional Indian jewelry. They are usually worn in pairs by women, one or more on each arm. Most Indian women prefer wearing either gold or glass bangles or combination of both. Inexpensive bangles made from plastic are slowly replacing those made by glass, but the ones made of glass are still preferred at traditional occasions such as marriages and on festivals.

        The designs range from simple to intricate handmade designs, often studded with precious and semi-precious stones such as diamonds, gems and pearls. Sets of expensive bangles made of gold and silver make a jingling sound. The imitation jewelry, tend to make a tinny sound when jingled.

        It is tradition that the bride will try to wear as many small glass bangles as possible at her wedding and the honeymoon will end when the last bangle breaks.
      }
      product = Product.create!( title: "Handmade bangles", price: 11, description: desc)
      handle_pictures_for_product(product, "product6")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'fashion')
    end

    def load_shoes
      print '.'
      desc = %q{
        People of India love color. Everything they use from top to bottom is colorful.

        Lets talk about shoes. Making good looking shoes is an art they have perfected over centuries. Making a shoe takes the whole village. And the whole village participates in the business of making and selling quality colorful shoes.
      }
      product = Product.create!( title: "Colorful shoes", price: 191, description: desc)
      handle_pictures_for_product(product, "product7")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'fashion')
    end

    def load_tag_watch
      print '.'
      desc = %q{
        Swiss label, TAG Heuer's Aquaracer 500M Ceramic watch embodies perfection, style and clean look.

        It has ceramic bezel and has the case is 41mm, significantly smaller than the 43mm out-going model. The case has been given softer curvier lines to
        create a more classic look.

        Following models are available:

        - Blue dial, blue ceramic bezel, steel
        - Black dial, black ceramic bezel, steel
        - Blue & gold, steel
        - full black, ceramic bezel, titanium carbide case
      }
      product = Product.create!( title: "TAG Heuer Aquaracer 500M Ceramic Watch", price: 3000, description: desc)
      handle_pictures_for_product(product, "product8")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'fashion')
    end

    def load_iphone_cover
      print '.'
      desc = %q{
        This is a hard case is for your iPhone 4. Fits both AT&T & Verizon models of the iPhone 4. The case has a wood like appearance. 
        It is not actual wood. It will protect it from scractches while also bringing it to life with some color! 

        It does not interfere with any buttons. It is available in many different colors. If you have a specific color in my then contact me.
      }
      product = Product.create!( title: "Hard wood case for iphone", price: 7.95, description: desc)
      handle_pictures_for_product(product, "product9")
      product.custom_field_answers.create(custom_field: CustomField.first, value: 'fashion')
    end

  end
end
