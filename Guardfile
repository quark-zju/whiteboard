# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard 'spork', :test_unit_env => { 'RAILS_ENV' => 'test' } do
#   watch('config/application.rb')
#   watch('config/environment.rb')
#   watch(%r{^config/environments/.+\.rb$})
#   watch(%r{^config/initializers/.+\.rb$})
#   watch('Gemfile')
#   watch('Gemfile.lock')
#   watch('spec/spec_helper.rb')
#   watch('test/test_helper.rb')
# end

# guard :test do
#   watch(%r{^lib/(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }
#   watch(%r{^test/.+_test\.rb$})
#   watch('test/test_helper.rb')  { "test" }
# 
#   # Rails example
#   watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
#   watch(%r{^app/controllers/(.+)\.rb$})              { |m| "test/functional/#{m[1]}_test.rb" }
#   watch(%r{^app/views/.+\.rb$})                      { "test/integration" }
#   watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
# end


guard 'spin' do
  # uses the .rspec file
  # --colour --fail-fast --format documentation --tag ~slow
  # watch(%r{^spec/.+_spec\.rb})
  # watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  # watch(%r{^app/(.+)\.haml})                         { |m| "spec/#{m[1]}.haml_spec.rb" }
  # watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  # watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }
  
  # TestUnit
  watch(%r|^test/(.*)_test\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
  watch(%r|^app/controllers/(.*)\.rb|) { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r|^app/views/(.*)/.*|) { |m| "test/functional/#{m[1]}_controller_test.rb" }
  watch(%r|^app/models/(.*)\.rb|)      { |m| "test/unit/#{m[1]}_test.rb" }
end
