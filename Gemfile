source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'slim', '1.0.4'
gem 'zurb-foundation', '2.1.0'
# gem 'client_side_validations', '3.1.3'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  # gem 'spork', '0.9.0.rc9'
  # gem 'spork-testunit', :git => 'https://github.com/sporkrb/spork-testunit.git'
  # gem 'guard-spork', '0.3.2'
  # gem 'guard-test', '0.4.2'
  gem 'guard-spin', '0.1.2'
  gem 'guard', '0.8.8'
  # gem 'ruby-prof'
  # gem 'libnotify', :require => false
  # gem 'rb-inotify', :require => false
  # gem 'rspec-rails'
end


group :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end

group :production do
  gem 'pg'
  gem 'therubyracer-heroku'
end
