require "spec_helper"

describe Api::V1::ClassificationOptionsController, group: :api do
  
  before do
    @account = FactoryGirl.create(:account1)
    @job_classification_option = FactoryGirl.create :business_unit, account: @account
  end

  context 'when logged in' do
  
    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/account_job_classification_options", account_id: @account.slug
      expect(response).to be_success
      expect(json[0]['name']).to eq(@account.classification_options.first.name)
    end
  
    it 'should return classification options' do
      get "/api/v1/account_job_classification_options/#{@job_classification_option.id}"
      expect(response).to be_success
      expect(json['name']).to eq(@job_classification_option.name)
    end
  
    it 'should create classification options' do
      post "/api/v1/account_job_classification_options", account_id: @account.slug, name: 'Lorem'
      expect(response).to be_success
      expect(json['name']).to eq('Lorem')
    end
  
    it 'should return validation errors' do
      post "/api/v1/account_job_classification_options", account_id: @account.slug, name: ''
      expect(response.status).to eq(422)
      expect(json['errors']).to eq(["Name can't be blank"])
    end

    it 'should return validation uniq errors' do
      post "/api/v1/account_job_classification_options", account_id: @account.slug, name: 'Dolor'
      expect(response.status).to eq(200)
      post "/api/v1/account_job_classification_options", account_id: @account.slug, name: 'Dolor'
      expect(response.status).to eq(422)
      expect(json['errors']).to eq(["Name has already been taken"])
    end

    it 'should update classification options' do
      put "/api/v1/account_job_classification_options/#{@job_classification_option.id}", name: 'blabla'
      expect(response).to be_success
      expect(json['name']).to eq('blabla')
    end

    it 'should destroy classification options' do
      expect {
        delete "/api/v1/account_job_classification_options/#{@job_classification_option.id}"
        expect(response).to be_success
      }.to change{AccountJobClassificationOption.count}.by(-1)
    end

  end

  context 'when logged out' do
  
    it 'should return 401 on collection' do
      get "/api/v1/account_job_classification_options", account_id: @account.slug
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show' do
      get "/api/v1/account_job_classification_options/#{@job_classification_option.id}"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create' do
      post "/api/v1/account_job_classification_options", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_job_classification_options/#{@job_classification_option.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_job_classification_options/#{@job_classification_option.id}"
      expect(response.status).to eq(401)
    end
  
  end
  
  context 'when logged in but without permission' do
  
    before do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end

    after do
      logout(:user)
    end

    it 'should return 401 on collection' do
      get "/api/v1/account_job_classification_options", account_id: @account.slug
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show' do
      get "/api/v1/account_job_classification_options/#{@job_classification_option.id}"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create' do
      post "/api/v1/account_job_classification_options", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_job_classification_options/#{@job_classification_option.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_job_classification_options/#{@job_classification_option.id}"
      expect(response.status).to eq(401)
    end
  
  end

end