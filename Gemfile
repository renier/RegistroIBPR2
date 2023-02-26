source 'https://rubygems.org'

ruby '~> 3.2.1'

gem 'bundler', '2.4.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.7.2'
gem 'nokogiri', '~> 1.13.10'
gem 'webpacker' # default javascript compiler in rails 6
gem 'net-http' # to silence some constant definition warnings

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.0'
gem 'textacular', '~> 5.5.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11.5'

# For Authentication/Authorization
gem 'devise'

# For pagination of collections in views
gem 'kaminari'

# For concurrent worker services (Printing)
gem 'timers', '4.3.2' # pinned. latest patch was not working with celluloid on 2/10/2023
gem 'celluloid'

# For the Frontend
gem 'bootstrap-sass', '~> 3.3'
gem 'font-awesome-sass', '~> 6.0'
gem 'bootbox-rails', '~> 0.4'
gem 'd3-rails', '~> 5.16'

group :development, :staging do
  gem 'puma', '~> 5.6.5'
  gem 'web-console', '~> 4.2'
  gem 'listen'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
