# frozen_string_literal: true

require 'spec_helper'
require 'capybara/rspec'

RSpec.configuration.before(:each, file_path: "./spec/rspec/scenarios_spec.rb") do
  @in_filtered_hook = true
end

feature "if fscenario aliases focused tag then" do
  fscenario "scenario should have focused meta tag" do |example|
    expect(example.metadata[:focus]).to eq true
  end
end

feature "if xscenario aliases to pending then" do
  xscenario "this test should be 'temporarily disabled with xscenario'" do
  end
end