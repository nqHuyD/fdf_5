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
Rails.application.config.assets.precompile += %w( approve_order_errors.js )
Rails.application.config.assets.precompile += %w( order_list_modal.js )
Rails.application.config.assets.precompile += %w( ranking_product.js )
Rails.application.config.assets.precompile += %w( font-face.css )
Rails.application.config.assets.precompile += %w( font-awesome-4.7/css/font-awesome.min.css )
Rails.application.config.assets.precompile += %w( font-awesome-5/css/fontawesome-all.min.css )
Rails.application.config.assets.precompile += %w( mdi-font/css/material-design-iconic-font.min.css )
Rails.application.config.assets.precompile += %w( bootstrap-4.1/bootstrap.min.css )
Rails.application.config.assets.precompile += %w( animsition/animsition.min.css )
Rails.application.config.assets.precompile += %w( bootstrap-progressbar/bootstrap-progressbar-3.3.4.min.css )
Rails.application.config.assets.precompile += %w( wow/animate.css )
Rails.application.config.assets.precompile += %w( css-hamburgers/hamburgers.min.css )
Rails.application.config.assets.precompile += %w( slick/slick.css )
Rails.application.config.assets.precompile += %w( select2/select2.min.css )
Rails.application.config.assets.precompile += %w( perfect-scrollbar/perfect-scrollbar.css )
Rails.application.config.assets.precompile += %w( theme.css )
Rails.application.config.assets.precompile += %w( jquery-3.2.1.min.js )
Rails.application.config.assets.precompile += %w( bootstrap-4.1/popper.min.js )
Rails.application.config.assets.precompile += %w( bootstrap-4.1/bootstrap.min.js )
Rails.application.config.assets.precompile += %w( slick/slick.min.js )
Rails.application.config.assets.precompile += %w( wow/wow.min.js )
Rails.application.config.assets.precompile += %w( animsition/animsition.min.js )
Rails.application.config.assets.precompile += %w( bootstrap-progressbar/bootstrap-progressbar.min.js )
Rails.application.config.assets.precompile += %w( counter-up/jquery.waypoints.min.js )
Rails.application.config.assets.precompile += %w( counter-up/jquery.counterup.min.js )
Rails.application.config.assets.precompile += %w( circle-progress/circle-progress.min.js )
Rails.application.config.assets.precompile += %w( perfect-scrollbar/perfect-scrollbar.js )
Rails.application.config.assets.precompile += %w( chartjs/Chart.bundle.min.js )
Rails.application.config.assets.precompile += %w( select2/select2.min.js )
Rails.application.config.assets.precompile += %w( admin_javascript/user_admin_data.js )
Rails.application.config.assets.precompile += %w( admin_javascript/order_admin_data.js )
Rails.application.config.assets.precompile += %w( admin_javascript/category_admin_data.js )
Rails.application.config.assets.precompile += %w( admin_javascript/product_admin_data.js )
Rails.application.config.assets.precompile += %w( admin_javascript/product_admin_destroy_data.js )
Rails.application.config.assets.precompile += %w( main.js )
