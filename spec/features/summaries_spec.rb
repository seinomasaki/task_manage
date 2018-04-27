require 'rails_helper'

Rspec.feature 'Summaries', type: :feature do
  describe 'click entry button' do
    # before do
    #   @task = FactoryGirl.create(:summary)
    # end
    it 'create new task' do
      expect {
        visit new_summary_path
        fill_in 'タスク名', with: '山形'
        fill_in 'ラベル', with: '上山'
        fill_in '期限', with: '1993/07/03 00:00'
        fill_in '内容', with: '地元'
        fill_in 'ステータス', from: '完了'
        fill_in '優先度', from: '最高'
        click_button '登録'
      }.to change(Summary, :count).by(1)
    end
  end
end