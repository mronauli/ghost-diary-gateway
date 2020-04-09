require 'rails_helper'

RSpec.describe 'Home Index -' do
  describe 'Connecting with Github -' do
    before(:each) do
      @group = Group.create!(name: 'Test Group')
      User.create!(name: 'other-user', uid: '1111', group: @group)

      auth_mock = {
        "provider"=>"github",
        "uid"=> '9999',
        "info"=> {"nickname"=>"test-user"}
      }

      OmniAuth.config.mock_auth[:github] = nil
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(auth_mock)
    end

    describe 'New User' do
      it 'can create an account with github' do
        visit '/'
        expect(page).to have_content('Welcome!')
        expect(page).to_not have_content('Logged in as ')

        click_link 'Log in with GitHub'

        expect(current_path).to eq('/')
        expect(page).to have_content('Logged in as test-user')
        expect(page).to_not have_content('Logged in as other-user')
        expect(page).to_not have_link('Log in with GitHub')
      end
    end

    describe 'Existing User' do
      it 'can log in' do
        User.create!(name: 'test-user', uid: '9999', group: @group)
        visit '/'

        click_link 'Log in with GitHub'

        expect(current_path).to eq('/')
        expect(page).to have_content('Logged in as test-user')
        expect(page).to_not have_link('Log in with GitHub')
      end
    end
  end
end
