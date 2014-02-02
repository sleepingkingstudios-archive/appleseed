# spec/routing/admin/settings_spec.rb

require 'spec_helper'

RSpec.describe 'routes for Admin::Settings' do
  include Appleseed::SharedExamples::RoutesToResource

  expect_behavior 'routes to singular resource', 'admin/settings', :only => %i(show update) do
    let(:controller_path) { 'admin/settings' }
  end # expect behavior

  expect_behavior 'does not route to singular resource', 'admin/settings', :except => %i(show update) do
    let(:controller_path) { 'admin/settings' }
  end # expect behavior
end # describe
