# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
end

guard :rspec, cmd: 'zeus rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }

  # run the model specs related to the changed model
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }

  # Controller changes
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }

  watch('config/routes.rb')                           { "spec/controllers" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('spec/rails_helper.rb')                       { "spec" }
  watch('spec/spec_helper.rb')                        { "spec" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/acceptance/#{m[1]}" }
  watch(%r{^app/views/(.+)/(.*)\.(.*)\.(erb|haml|slim)$})     { |m| "spec/acceptance/#{m[1]}" }
  watch(%r{^app/views/(.+)/_.*\.(erb|haml|slim)$})     { |m| "spec/acceptance/#{m[1].partition('/').first}/#{m[1].partition('/').last}_spec.rb" }
end

# Checks any changed ruby file for code grammar
guard :rubocop, all_on_start: false, cli: ['--format', 'fuubar', '--rails', '--out', 'log/rubocop.log'] do
  watch(%r{^(.+)\.rb$}) { |m| "#{m[1]}.rb" }
end

# Restarts server on config changes
guard 'rails', zeus: true, daemon: true do
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end

# Restarts all jasmine tests on any js change
guard :jasmine, all_on_start: false, server_mount: '/specs' do
  watch(%r{^app/(.+)\.(js\.coffee|js|coffee)}) { "spec/javascripts" }
end
