require "spec_helper"

describe Api::V1::UsersController, group: :api do

  context 'when logged in' do

    before(:each) do
      @account = FactoryGirl.create(:account1)
      @user =  FactoryGirl.create(:user_account_user, account: @account)
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)

      login_as @account_manager
    end

    it 'should return collection' do
      get "/api/v1/users", account_id: @account.slug, first: @user.first, last: @user.last
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return user on show' do
      get "/api/v1/users/#{@user.id}", account_id: @account.slug
      expect(response).to be_success
      expect(json['id']).to eq(@user.id)
    end

    it 'should return found user last name' do
      get "/api/v1/users/search", account_id: @account.slug, query: @user.last
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

  end

  context 'when logged out' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @account = FactoryGirl.create(:account1)
     end

    it 'should return 401 on users collection' do
      get "/api/v1/users", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show user' do
      get "/api/v1/users/#{@user.id}", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return found user last name' do
      get "/api/v1/users/search", account_id: @account.slug, query: @user.last
      expect(response.status).to eq(401)
    end
  end

  context 'when logged in but without permission' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @account = FactoryGirl.create(:account1)

      login_as @user
    end

    it 'should return 401 on users collection' do
      get "/api/v1/users", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show user' do
      get "/api/v1/users/#{@user.id}", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return found user last name' do
      get "/api/v1/users/search", account_id: @account.slug, query: @user.last
      expect(response.status).to eq(401)
    end

  end

end