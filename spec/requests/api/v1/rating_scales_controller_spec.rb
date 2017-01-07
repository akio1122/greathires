require "spec_helper"

describe Api::V1::RatingScalesController, group: :api do

  before do
    @account = FactoryGirl.create(:account1)
    @rating_scale = @account.rating_scales.first
  end

  context 'when logged in' do

    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/account_rating_scales", account_id: @account.slug
      expect(response).to be_success
      expect(json[0]['name']).to eq('Thumbs Up')
    end

    it 'should return rating scale' do
      get "/api/v1/account_rating_scales/#{@rating_scale.id}"
      expect(response).to be_success
      expect(json['name']).to eq('Thumbs Up')
    end

    it 'should create rating scale' do
      post "/api/v1/account_rating_scales", account_id: @account.slug, name: 'Lorem', handle: 'lorem', is_active_for_traits: true
      expect(response).to be_success
      expect(json['name']).to eq('Lorem')
      expect(json['is_active_for_traits']).to eq(true)
    end

    it 'should return validation errors' do
      post "/api/v1/account_rating_scales", account_id: @account.slug, name: ''
      expect(response.status).to eq(422)
      expect(json['errors']).to eq(["Name can't be blank", "Handle can't be blank"])
    end

    it 'should update rating scale' do
      put "/api/v1/account_rating_scales/#{@rating_scale.id}", name: 'blabla'
      expect(response).to be_success
      expect(json['name']).to eq('blabla')
    end

    it 'should destroy rating scale' do
      expect {
        delete "/api/v1/account_rating_scales/#{@rating_scale.id}"
        expect(response).to be_success
      }.to change{AccountRatingScale.count}.by(-1)
    end

  end

  context 'when logged out' do

    it 'should return 401 on collection' do
      get "/api/v1/account_rating_scales", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/account_rating_scales/#{@rating_scale.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/account_rating_scales", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_rating_scales/#{@rating_scale.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_rating_scales/#{@rating_scale.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on collection' do
      get "/api/v1/account_rating_scales", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/account_rating_scales/#{@rating_scale.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/account_rating_scales", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_rating_scales/#{@rating_scale.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_rating_scales/#{@rating_scale.id}"
      expect(response.status).to eq(401)
    end

  end

end
