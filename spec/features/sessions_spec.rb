require 'rails_helper'

RSpec.feature 'Sessions', type: :feature, js: true do
  describe 'session(login, logout)' do
    context 'login前にtask一覧に飛んでみる' do
      it 'ログインしてください' do
        visit summaries_path
        expect(page).to have_content 'ログインしてください'
      end
    end
    context 'user登録' do
      it 'Userが増える' do
        expect {
          visit new_user_path
          fill_in 'user[name]', with: 'seino'
          fill_in 'user[email]', with: 'seino@g.com'
          fill_in 'user[password]', with: 'pass'
          fill_in 'user[password_confirmation]', with: 'pass'
          click_button '登録'
          expect(page).to have_content '作成しました。'
        }.to change(User, :count).by(1)
      end
    end
    context 'user unique check' do
      before do
        FactoryGirl.create(:user, :general)
        visit new_user_path
        fill_in 'user[name]', with: 'seino'
        fill_in 'user[email]', with: 'seino@g.com'
        fill_in 'user[password]', with: 'pass'
        fill_in 'user[password_confirmation]', with: 'pass'
        click_button '登録'
      end
      it 'Emailアドレスはすでに存在します。' do
        expect(page).to have_content 'Emailアドレスはすでに存在します'
      end
    end
    context 'login' do
      before do
        FactoryGirl.create(:user, :general)
      end
      it 'EmailまたはPasswordが間違っています。' do
        visit new_session_path
        fill_in 'session[email]', with: 'seino@g.com'
        fill_in 'session[password]', with: 'punch'
        click_button 'ログイン'
        expect(page).to have_content 'EmailまたはPasswordが間違っています。'
      end
      it 'EmailまたはPasswordが間違っています。' do
        visit new_session_path
        fill_in 'session[email]', with: 'masaki@g.com'
        fill_in 'session[password]', with: 'pass'
        click_button 'ログイン'
        expect(page).to have_content 'EmailまたはPasswordが間違っています。'
      end
      it 'ログインしました。' do
        visit new_session_path
        fill_in 'session[email]', with: 'seino@g.com'
        fill_in 'session[password]', with: 'pass'
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました。'
      end
    end
    context 'logout' do
      before do
        FactoryGirl.create(:user, :general)
        visit new_session_path
        fill_in 'session[email]', with: 'seino@g.com'
        fill_in 'session[password]', with: 'pass'
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました。'
        click_on 'ログアウト'
      end
      it 'ログアウトしました。' do
        expect(page).to have_content 'ログアウトしました。'
      end
    end
    context 'logout後にtask一覧に飛んでみる' do
      it 'ログインしてください' do
        visit summaries_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end
end