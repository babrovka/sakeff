source 'https://rubygems.org'

gem 'rails', '4.1.2'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.1'

# Ease REST controllers creation
gem 'inherited_resources'
gem 'paperclip'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'webdack-uuid_migration'
gem 'hipchat'
gem 'cancancan', '~> 1.8'
gem 'devise'
gem 'awesome_nested_set'
gem 'workflow'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'mail-logger'
gem 'normalizr'
gem 'validates_timeliness',
  github: 'razum2um/validates_timeliness',
  ref: 'b195081f6aeead619430ad38b0f0dfe4d4981252'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'spring-commands-rspec'

  # Integrates jasmine js testing
  gem 'jasmine-rails'
  # With guard
  gem 'guard-jasmine', git: "git://github.com/guard/guard-jasmine.git", branch: "jasmine-2"

  # Checks ruby code grammar
  gem 'rubocop', require: false
  # With rspec
  gem 'rubocop-rspec'
  # With guard
  gem 'guard-rubocop'

  gem 'capistrano'
  gem 'rvm-capistrano'
end

group :development do
  # Better displays 500 errors
  gem 'better_errors'
  # And shows console on their pages
  gem 'binding_of_caller'

  # Automatically adds annotations to models
  gem 'annotate'

  # Automagically launches tests for changed files
  gem 'guard'
  gem 'guard-rspec', require: false
  # And updates gems when needed
  gem 'guard-bundler', require: false

  # For guard and other notifications in native mac
  gem 'terminal-notifier-guard', '~> 1.6.1'

  gem 'quiet_assets'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara', '~> 2.4.1'
  gem 'poltergeist'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'test_after_commit'
  gem 'guard-coffeelint', git: 'git@github.com:meagar/guard-coffeelint.git'
end

gem 'spreadsheet'

gem 'autoprefixer-rails'
gem 'simple_form', '>= 3.1.0.rc1'
gem 'slim-rails'


gem 'execjs', '~> 2.2.1'
gem 'therubyracer', '~> 0.12.1'

gem 'faker'
gem 'populator'
gem 'private_pub'

gem 'chosen-rails'
gem 'font-awesome-rails'
gem 'select2-rails'
gem 'compass'
gem 'compass-rails', '~> 1.1.7'
gem 'react-rails', git: 'https://github.com/reactjs/react-rails'
gem 'i18n-js'
gem 'momentjs-rails'
gem 'underscore-rails'
gem 'draper', '~> 1.3'
# gem 'draper_simple_form', require: 'draper/simple_form'
gem 'bootstrap-sass', '~> 3.2'
gem 'simple-navigation'
gem 'thin'

# For nested forms easy handling
gem 'nested_form'

# for Library code highlighting
# берем напрямую из репа,потому что только на github была обработка slim
# gem 'rouge', git: 'https://github.com/jneen/rouge.git'
gem 'rouge'

# Helps to get locales for enums in forms, etc
# https://github.com/zmbacker/enum_help
gem 'enum_help'

gem 'gon'

# For documents module
gem 'has_scope'
gem 'responders'

# Pagination
gem 'kaminari'

gem 'ransack', git: 'git@github.com:activerecord-hackery/ransack.git', branch: 'rails-4.1'

gem 'squeel', git: 'https://github.com/activerecord-hackery/squeel'

gem 'russian'

# gem 'icheck-rails'
gem 'icheck-rails', github: 'ricardodovalle/icheck-rails'

# WYSIWYG Editor
gem 'ckeditor'

# Something for PDF in documents module
gem 'rmagick', :require => 'RMagick'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', '0.9.9.1'

# просмотр pdf в красивом окне
gem 'pdfjs_rails'

# / For documents module

# For pdf rendering from ruby
gem 'prawn'

gem 'amoeba'

# EOF
# Please add your gem above for better merging
