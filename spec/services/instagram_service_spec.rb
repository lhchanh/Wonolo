require 'spec_helper'

RSpec.describe InstagramService, type: :services do
  describe 'search_posts' do
    it 'return an empty array with empty search params' do
      search_params = {}
      assert_equal [], InstagramService.new.search_posts(search_params)
    end

    it ''
  end
end