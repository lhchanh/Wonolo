require "rails_helper"

RSpec.describe HomeHelper, type: :helper do
  describe '#instagram_profile' do
    it 'Navigate to instagram profile url with instagram username' do
      userrname = 'lhchanh'
      expected_result = 'https://instagram.com/lhchanh'
      expect(instagram_profile(userrname)).to eql(expected_result)
    end
  end
end