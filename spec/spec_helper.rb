require 'factory_girl_rails'
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    config.include FactoryGirl::Syntax::Methods
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:all) do
    Hovercat.config()
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
