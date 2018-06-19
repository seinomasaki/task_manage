require 'rails_helper'

RSpec.feature 'Labels', type: :feature, js: true do
  describe 'label' do
    before do
      FactoryGirl.create(:user, :general)
      visit new_session_path
      fill_in 'session[email]', with: 'seino@g.com'
      fill_in 'session[password]', with: 'pass'
      click_button 'ログイン'
    end

    context 'label登録' do
      it 'label count up 1' do
        expect {
          visit labels_path
          fill_in 'label[name]', with: 'godzilla'
          click_button '登録'
          expect(page).to have_content '作成しました。'
        }.to change(Label, :count).by(1)
      end
    end

    context 'label delete' do
      before do
        FactoryGirl.create(:label)
        visit labels_path
      end
      it 'label count down 1' do
        expect {
          page.all('tbody tr')[0].find_by_id('delete_id').click
          page.accept_confirm
          expect(page).to have_content '削除しました。'
        }.to change(Label, :count).by(-1)
      end
    end
  end
end