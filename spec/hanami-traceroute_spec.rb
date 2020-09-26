require "hanami-traceroute"
require 'hanami'
require "spec_helper"

describe HanamiTraceroute do

  EXPECTED_ACTIONS = "Action \nWeb::Controllers::Timeline::Index Web::Controllers::Dashboard::Index Web::Controllers::Sales::Index Web::Controllers::Stores::Index "

  before do
    Hanami::Components.resolved('web.routes')
    allow(Hanami).to receive(:root).and_return("spec/dummy_app")
    allow(Hanami::Components['web.routes']).to receive_message_chain(:inspector, :to_s).and_return(EXPECTED_ACTIONS)
  end

  context "with unused_routes" do
    it do
      expect(HanamiTraceroute.unused_routes).to eq ["Dashboard#Index", "Sales#Index"]
    end
  end

  context "with unreachable_action_methods" do
    it do
      expect(HanamiTraceroute.unreachable_action_methods).to eq ["Stores#Show"]
    end
  end
end
