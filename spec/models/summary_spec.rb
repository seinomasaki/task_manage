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

  describe 'search test' do
    subject { described_class.search(params) }
    before do
      FactoryGirl.create(:summary, task_name: 'task1', priority: '1')
      FactoryGirl.create(:summary, task_name: 'task2', priority: '1')
      FactoryGirl.create(:summary, task_name: 'task22', priority: '4')
      FactoryGirl.create(:summary, task_name: 'task222', priority: '1')
      FactoryGirl.create(:summary, task_name: 'task3', priority: '2')
      FactoryGirl.create(:summary, task_name: 'task334', priority: '2')
      FactoryGirl.create(:summary, task_name: 'task33', priority: '2')
      FactoryGirl.create(:summary, task_name: 'task4', priority: '2')
      FactoryGirl.create(:summary, task_name: 'task4', priority: '4')
    end
    context 'text field' do
      let(:params) { { task_name: 'task2' } }
      it 'search same task_name' do
        expect(subject.size).to eq 3
      end
    end

    context 'search same priority' do
      let(:params) { { priority: '4' } }
      it 'search same priority' do
        expect(subject.size).to eq 2
      end
    end
  end
end