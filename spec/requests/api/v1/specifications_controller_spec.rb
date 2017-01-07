require "spec_helper"

describe Api::V1::SpecificationsController, group: :api do

  before do
    @account = FactoryGirl.create(:account1)
    @specification_section = @account.specification_sections.first
  end

  context 'when logged in' do

    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/account_specification_sections", account_id: @account.slug
      expect(response).to be_success
      expect(json[0]['name']).to eq('Required Skills')
    end

    it 'should return specification section' do
      get "/api/v1/account_specification_sections/#{@specification_section.id}"
      expect(response).to be_success
      expect(json['name']).to eq('Required Skills')
    end

    it 'should create specification section' do
      post "/api/v1/account_specification_sections", account_id: @account.slug, name: 'Lorem'
      expect(response).to be_success
      expect(json['name']).to eq('Lorem')
    end

    it 'should return validation errors' do
      post "/api/v1/account_specification_sections", account_id: @account.slug, name: ''
      expect(response.status).to eq(422)
      expect(json['errors']).to eq(["Name can't be blank"])
    end

    it 'should update specification section' do
      put "/api/v1/account_specification_sections/#{@specification_section.id}", name: 'blabla'
      expect(response).to be_success
      expect(json['name']).to eq('blabla')
    end

    it 'should destroy specification section' do
      expect {
        delete "/api/v1/account_specification_sections/#{@specification_section.id}"
        expect(response).to be_success
      }.to change{AccountSpecificationSection.count}.by(-1)
    end

  end

  context 'when logged out' do

    it 'should return 401 on collection' do
      get "/api/v1/account_specification_sections", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/account_specification_sections/#{@specification_section.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/account_specification_sections", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_specification_sections/#{@specification_section.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_specification_sections/#{@specification_section.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on collection' do
      get "/api/v1/account_specification_sections", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/account_specification_sections/#{@specification_section.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/account_specification_sections", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_specification_sections/#{@specification_section.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_specification_sections/#{@specification_section.id}"
      expect(response.status).to eq(401)
    end

  end

end
