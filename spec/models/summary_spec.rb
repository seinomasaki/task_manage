require 'rails_helper'

RSpec.describe Summary, type: :model do
  describe 'validation' do
    it 'without task_name' do
      task = FactoryGirl.build(:summary, task_name: nil)
      task.valid?
      expect(task.errors[:task_name]).to include('を入力してください')
    end

    it 'not select status' do
      task = FactoryGirl.build(:summary, status: nil)
      task.valid?
      expect(task.errors[:status]).to include('を入力してください')
    end

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
      FactoryGirl.create(:summary, task_name: '222task222', priority: '1')
      FactoryGirl.create(:summary, task_name: 'task3', priority: '2')
      FactoryGirl.create(:summary, task_name: 'task334', priority: '2')
      FactoryGirl.create(:summary, task_name: 'task33', priority: '2')
      FactoryGirl.create(:summary, task_name: 'task4', priority: '2')
      FactoryGirl.create(:summary, task_name: 'task4', priority: '4')
      FactoryGirl.create(:summary, task_name: 'kkksitask2kasf', priority: '4')
    end
    context 'search same task_name' do
      let(:params) { { task_name: 'task2' } }
      it 'tasks size = 5' do
        expect(subject.size).to eq 5
      end
    end

    context 'search same priority' do
      let(:params) { { priority: '4' } }
      it 'search count = 3' do
        expect(subject.size).to eq 3
      end
    end
  end
end