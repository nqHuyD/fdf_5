# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.

Rails.application.config.assets.paths << Rails.root.join('node_modules')
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.precompile += %w( jquery.wmuSlider.js )
Rails.application.config.assets.precompile += %w( jquery.flexisel.js )
Rails.application.config.assets.precompile += %w( easyResponsiveTabs.js )
Rails.application.config.assets.precompile += %w( categoryrender.js )
Rails.application.config.assets.precompile += %w( information_product.js )
Rails.application.config.assets.precompile += %w( imagezoom.js )
Rails.application.config.assets.precompile += %w( quanity.single-product.js )
Rails.application.config.assets.precompile += %w( jquery.flexslider.js )
Rails.application.config.assets.precompile += %w( pagination.js )
Rails.application.config.assets.precompile += %w( addcart.js )
Rails.application.config.assets.precompile += %w( filter_price.js )
Rails.application.config.assets.precompile += %w( cart_checkout.js )
