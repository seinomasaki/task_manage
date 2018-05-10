require 'rails_helper'

RSpec.feature 'Summaries', type: :feature do
  DatabaseRewinder.clean_all

  describe 'click entry button' do
    it 'create new task' do
      expect {
        visit new_summary_path
        fill_in 'summary[task_name]', with: '山形'
        fill_in 'summary[label]', with: '上山'
        fill_in 'summary[time_limit]', with: '1993/07/03 00:00'
        fill_in 'summary[contents]', with: '地元'
        select '完了', from: 'summary[status]'
        select '4', from: 'summary[priority]'
        click_button '登録'
      }.to change(Summary, :count).by(1)
    end
  end


  describe 'click delete link' do
    before do
      1.upto(1) do |row|
        p FactoryGirl.create(:summary, time_limit: Date.today + row.hour)
      end
    end
    it 'task delete' do
      visit summaries_path
      expect {
        page.all('tbody tr')[0].find_by_id('delete_id').click
      }.to change(Summary, :count).by(-1)
    end
  end


  describe 'edit task after update' do
    before do
      @task = FactoryGirl.create(:summary)
      visit summaries_path
      page.all('tbody tr')[0].find_by_id('edit_id').click
    end
    let(:task) { Summary.find(@task.id) }
    context 'task word change' do
      let(:text) { 'Rspec' }
      it 'rewrite label' do
        fill_in 'summary[label]', with: text
        click_button '登録'
        expect(text).to eq(task.label)
      end
    end
  end

  # let(:first) { all('tbody tr')[0].all('td')[3].text }
  # let(:second) { all('tbody tr')[1].all('td')[3].text }
  describe 'sort tasks list' do
    before do
      1.upto(2) do |row|
        FactoryGirl.create(:summary, priority: row, created_at: Date.today + row)
      end
      visit summaries_path
    end
    # defaultで作成日順に昇順されている
    it 'sort by priority' do
      expect(all('tbody tr')[0].all('td')[3].text).not_to eq(all('tbody tr')[1].all('td')[3].text)
      expect(all('tbody tr')[0].all('td')[3].text).to eq('2')
      # p first
      # p all('tbody tr')[0].all('td')[3].text
      click_on('優先度')
      # p first
      # p all('tbody tr')[0].all('td')[3].text
      expect(all('tbody tr')[0].all('td')[3].text).not_to eq(all('tbody tr')[1].all('td')[3].text)
      expect(all('tbody tr')[0].all('td')[3].text).to eq('1')
      expect(all('tbody tr')[1].all('td')[3].text).to eq('2')
    end
  end
end