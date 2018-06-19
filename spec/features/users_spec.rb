require 'rails_helper'

RSpec.feature 'users', type: :feature, js: true do
  describe 'general user' do
    before do
      FactoryGirl.create(:user, :general)
      FactoryGirl.create(:user, :admin)
      visit new_session_path
      fill_in 'session[email]', with: 'seino@g.com'
      fill_in 'session[password]', with: 'pass'
      click_button 'ログイン'
    end
    context 'my profile change' do
      before do
        visit edit_user_path(User.first.id)
        page.save_screenshot '~/Desktop/screenshot.png'
        fill_in 'user[name]', with: 'masaki'
        click_button '登録'
        expect(page).to have_content '編集しました。'
      end
      it 'name: seino -> masaki' do
        expect('masaki').to eq(User.first.name)
      end
    end
    context 'other profile change' do
      it 'incapable: 不正なアクセスを確認しました。' do
        visit edit_user_path(User.second.id)
        expect(page).to have_content '不正なアクセスを確認しました。'
      end
    end
  end

  describe 'admin user' do
    before do
      FactoryGirl.create(:user, :general)
      FactoryGirl.create(:user, :admin)
      visit new_session_path
      fill_in 'session[email]', with: 'segasdgaino@g.com'
      fill_in 'session[password]', with: 'password'
      click_button 'ログイン'
    end
    context 'my profile change' do
      before do
        visit edit_user_path(User.second.id)
        fill_in 'user[name]', with: 'godzilla'
        click_button '登録'
        expect(page).to have_content '編集しました。'
      end
      it 'name: gasdgad -> godzilla' do
        expect('godzilla').to eq(User.second.name)
      end

      before do
        visit edit_admin_user_path(User.second.id)
        uncheck 'user_admin'
        click_button '登録'
      end
      it '管理者がいなくなってしまします。処理を戻します。' do
        expect(page).to have_content '管理者がいなくなってしまします。処理を戻します。'
      end
    end

    context 'user destroy' do
      it 'user count: -1' do
        expect {
          visit admin_users_path
          page.all('tbody tr')[0].find_by_id('delete_id').click
          page.accept_confirm
          expect(page).to have_content '削除しました。'
        }.to change(User, :count).by(-1)
      end
    end
  end
end