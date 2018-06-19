require 'rails_helper'

RSpec.feature 'Summaries', type: :feature, js: true do
  describe 'click entry button' do
    before do
      FactoryGirl.create(:user, :general)
      FactoryGirl.create(:user, :admin)
      visit new_session_path
      fill_in 'session[email]', with: 'seino@g.com'
      fill_in 'session[password]', with: 'pass'
      click_button 'ログイン'
    end

    it 'create new task' do
      visit new_summary_path
      expect {
        fill_in 'summary[task_name]', with: '山形'
        fill_in 'summary[label]', with: '上山'
        # select '1993/07/03 00:00', from: 'summary[time_limit]'
        fill_in 'summary[contents]', with: '地元'
        select '完了', from: 'summary[status]'
        select '4', from: 'summary[priority]'
        click_button '登録'
        page.accept_confirm
        expect(page).to have_content '作成しました。'
      }.to change(Summary, :count).by(1)
    end
  end


  describe 'click delete link' do
    before do
      1.upto(1) do |row|
        FactoryGirl.create(:summary, time_limit: Date.today + row.hour)
      end
    end
    it 'task delete' do
      visit summaries_path
      expect {
        page.all('tbody tr')[0].find_by_id('delete_id').click
        page.accept_confirm
        expect(page).to have_content '削除しました。'
      }.to change(Summary, :count).by(-1)
    end
  end


  describe 'update task' do
    before do
      visit summaries_path
      page.all('tbody tr')[0].find_by_id('edit_id').click
    end
    let(:task) { FactoryGirl.create(:summary, label: 'before label') }
    context 'task word change' do
      before do
        fill_in 'summary[task_name]', with: 'Rspec'
        select '完了', from: 'summary[status]'
        select '4', from: 'summary[priority]'
        click_button '登録'
        page.accept_confirm
        expect(page).to have_content '編集しました。'
      end
      it 'summary[task_name]: ruby on rails (mySQL) -> Rspec' do
        expect('Rspec').to eq(task.task_name)
      end
    end
  end

  describe 'sort tasks list' do
    before do
      1.upto(3) do |row|
        FactoryGirl.create(:summary, priority: "#{row}", created_at: Date.today + row)
      end
      visit summaries_path
    end
    # defaultで作成日順に昇順されている
    it 'sort by priority' do
      expect(all('tbody tr')[0].all('td')[3].text).to eq('3')
      expect(all('tbody tr')[1].all('td')[3].text).to eq('2')
      expect(all('tbody tr')[2].all('td')[3].text).to eq('1')
      click_on('優先度')
      expect(all('tbody tr')[0].all('td')[3].text).to eq('1')
      expect(all('tbody tr')[1].all('td')[3].text).to eq('2')
      expect(all('tbody tr')[2].all('td')[3].text).to eq('3')
    end
  end
end