require "spec_helper"

describe Api::V1::ClassificationOptionsController, group: :api do

  before do
    @account = FactoryGirl.create(:account1)
    @job_classification_option = FactoryGirl.create :business_unit, account: @account
    @job_classification = FactoryGirl.create :job_classification, job_classification_option: @job_classification_option
  end

  context 'when logged in' do

    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/job_classifications", account_id: @account.slug, job_classification_option_id: @job_classification_option.id
      expect(response).to be_success
      expect(json[0]['name']).to eq(@job_classification_option.job_classifications.first.name)
    end

    it 'should return business unit' do
      get "/api/v1/job_classifications/#{@job_classification.id}"
      expect(response).to be_success
      expect(json['name']).to eq(@job_classification.name)
    end

    it 'should create business unit' do
      post "/api/v1/job_classifications", account_id: @account.slug, job_classification_option_id: @job_classification_option.id, name: 'Lorem'
      expect(response).to be_success
      expect(json['name']).to eq('Lorem')
    end

    it 'should return validation errors' do
      post "/api/v1/job_classifications", account_id: @account.slug, job_classification_option_id: @job_classification_option.id, name: ''
      expect(response.status).to eq(422)
      expect(json['errors']).to eq(["Name can't be blank"])
    end

    it 'should update business unit' do
      put "/api/v1/job_classifications/#{@job_classification.id}", name: 'blabla'
      expect(response).to be_success
      expect(json['name']).to eq('blabla')
    end

    it 'should destroy business unit' do
      expect {
        delete "/api/v1/job_classifications/#{@job_classification.id}"
        expect(response).to be_success
      }.to change{JobClassification.count}.by(-1)
    end

  end

  context 'when logged out' do

    it 'should return 401 on collection' do
      get "/api/v1/job_classifications", account_id: @account.slug, job_classification_option_id: @job_classification_option.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/job_classifications/#{@job_classification.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/job_classifications", account_id: @account.slug, job_classification_option_id: @job_classification_option.id, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/job_classifications/#{@job_classification.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/job_classifications/#{@job_classification.id}"
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
      get "/api/v1/job_classifications", account_id: @account.slug, job_classification_option_id: @job_classification_option.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/job_classifications/#{@job_classification.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/job_classifications", account_id: @account.slug, job_classification_option_id: @job_classification_option.id, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/job_classifications/#{@job_classification.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/job_classifications/#{@job_classification.id}"
      expect(response.status).to eq(401)
    end

  end

end
