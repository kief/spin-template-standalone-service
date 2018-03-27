require 'rspec/collection_matchers'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.add_formatter (:documentation)
end
