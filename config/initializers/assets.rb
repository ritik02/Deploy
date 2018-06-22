Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( home_page.js )
Rails.application.config.assets.precompile += %w( project.js )
Rails.application.config.assets.precompile += %w( user.js )
Rails.application.config.assets.precompile += %w( home-page.scss )
Rails.application.config.assets.precompile += %w( project-page.scss )
Rails.application.config.assets.precompile += %w( commit-page.scss )
Rails.application.config.assets.precompile += %w( deployment-page.scss )
