# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts', '**', '*')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( super_admin.js  library.js shared.js public.js documents.js )
Rails.application.config.assets.precompile += %w( super_admin.css library.css shared.css documents.css )
Rails.application.config.assets.precompile += %w( .svg .eot .woff .ttf )
Rails.application.config.assets.precompile += %w(.png .jpg .jpeg .gif)

