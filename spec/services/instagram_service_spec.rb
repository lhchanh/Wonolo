require 'spec_helper'

RSpec.describe InstagramService, type: :services do

  before do
    def instagram_service
      @service ||= InstagramService.new
    end
  end

  describe 'search_posts' do
    it 'return an empty array with empty search params' do
      search_params = {}
      assert_equal [], instagram_service.search_posts(search_params)
    end

    it 'return an empty array with search params missing lat or lng ' do
      search_params = {lat: '10.8230989', distance: 1}
      result = instagram_service.search_posts(search_params)
      assert_equal [], result
    end

    it 'return an array with full search params ' do
      search_params = {lat: '10.8230989', lng: '106.6296638' ,distance: 1}
      result = instagram_service.search_posts(search_params)
      expect(result.size).not_to eq(0)
    end

  end

  describe 'get_post' do
    it 'return nil when media_id has nil value' do
      media_id = nil
      result = instagram_service.get_post media_id
      expect(result).to eq(nil)
    end

    it 'should get post successfully when passing valid media_id value' do
      search_params = {lat: '10.8230989', lng: '106.6296638' ,distance: 1}
      result = instagram_service.search_posts(search_params)
      media_id = result.first.id
      result = instagram_service.get_post media_id
      expect(result).not_to eq(nil)
    end
  end
end