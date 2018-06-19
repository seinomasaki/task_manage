require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validation' do
    it 'errors = を入力してください' do
      label = FactoryGirl.build(:label, name: nil)
      label.valid?
      expect(label.errors[:name]).to include('を入力してください')
    end
  end
end
