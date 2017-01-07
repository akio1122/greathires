require "spec_helper"

describe Api::V1::InterviewRoundsController, group: :api do

  before do
    @account = FactoryGirl.create(:account1)
    @interview_round = @account.interview_rounds.first
  end

  context 'when logged in' do

    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/account_interview_rounds", account_id: @account.slug
      expect(response).to be_success
      expect(json[0]['name']).to eq('Resume Screen')
    end

    it 'should return interview round' do
      get "/api/v1/account_interview_rounds/#{@interview_round.id}"
      expect(response).to be_success
      expect(json['name']).to eq('Resume Screen')
    end

    it 'should create interview round' do
      post "/api/v1/account_interview_rounds", account_id: @account.slug, name: 'Lorem'
      expect(response).to be_success
      expect(json['name']).to eq('Lorem')
    end

    it 'should return validation errors' do
      post "/api/v1/account_interview_rounds", account_id: @account.slug, name: ''
      expect(response.status).to eq(422)
      expect(json['errors']).to eq(["Name can't be blank"])
    end

    it 'should update interview round' do
      put "/api/v1/account_interview_rounds/#{@interview_round.id}", name: 'blabla'
      expect(response).to be_success
      expect(json['name']).to eq('blabla')
    end

    it 'should destroy interview round' do
      expect {
        delete "/api/v1/account_interview_rounds/#{@interview_round.id}"
        expect(response).to be_success
      }.to change{AccountInterviewRound.count}.by(-1)
    end

  end

  context 'when logged out' do

    it 'should return 401 on collection' do
      get "/api/v1/account_interview_rounds", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/account_interview_rounds/#{@interview_round.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/account_interview_rounds", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_interview_rounds/#{@interview_round.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_interview_rounds/#{@interview_round.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on collection' do
      get "/api/v1/account_interview_rounds", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/account_interview_rounds/#{@interview_round.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/account_interview_rounds", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_interview_rounds/#{@interview_round.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_interview_rounds/#{@interview_round.id}"
      expect(response.status).to eq(401)
    end

  end

end
