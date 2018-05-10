require 'rails_helper'

RSpec.describe Summary, type: :model do
  describe 'validation' do
    it 'without task_name' do
      task = FactoryGirl.build(:summary, task_name: nil)
      task.valid?
      expect(task.errors[:task_name]).to include('を入力してください')
    end
  end

  describe 'input limit exceeded' do
    it 'task_name' do
      task = FactoryGirl.build(:summary, task_name: 'kasdfiaosdnafdaefdsadfasdfogasdsafaavfd')
      task.valid?
      expect(task.errors[:task_name]).to include('は25文字以内で入力してください')
    end
  end
end