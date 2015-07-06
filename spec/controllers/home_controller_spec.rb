require 'spec_helper'

RSpec.describe HomeController, :type => :controller do
  describe "GET index" do
    it "should allow get list posts" do
      get :index, lat: '10.8230989', lng: '106.6296638'
      expect(response).to be_success
    end

    it "should allow get list posts" do
      get :index
      expect(response).to be_success
    end

    it "should allow get post" do
      get :get_post
      expect(response).to be_success
    end
  end
end