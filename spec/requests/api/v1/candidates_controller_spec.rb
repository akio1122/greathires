require "spec_helper"

describe Api::V1::CandidatesController, group: :api do

  context 'when logged in' do

    before(:each) do
      @account = FactoryGirl.create(:account1)
      @user =  FactoryGirl.create(:user_account_user, account: @account)
      @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r', user_id: @user.id
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @account_manager
    end

    it 'should return collection' do
      get "/api/v1/account_candidates", account_id: @account.slug
      expect(response).to be_success
      expect(json.size).to eq(1)
    end

    it 'should return candidate' do
      get "/api/v1/account_candidates/#{@candidate.id}"
      expect(response).to be_success
    end

    it 'should create candidate' do
      expect {
        post "/api/v1/candidates", account_id: @account.slug, user_id: @user.id, first: 'John', last: 'Doe', email: 'john@mail.net', linkedin_id: '1234'
        expect(response).to be_success
      }.to change{AccountCandidate.count}.by(1)
    end

    it 'should return validation errors' do
      expect {
        post "/api/v1/account_candidates", account_id: @account.slug, user_id: @user.id, first: 'John', last: 'Doe', email: 'john@mail.net', linkedin_id: '-vqC-Cd32r'
        expect(response.status).to eq(422)
      }.not_to change{AccountCandidate.count}
    end

    it 'should delete candidate' do
      expect {
        delete "/api/v1/account_candidates/#{@candidate.id}"
        expect(response).to be_success
      }.to change{AccountCandidate.count}.by(-1)
    end
  end

  context 'when logged in but without permission' do

    before(:each) do
      @account = FactoryGirl.create(:account1)
      @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r', user_id: FactoryGirl.create(:user_account_user, account: @account).id
      @user =  FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on collection' do
      get "/api/v1/account_candidates", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/account_candidates/#{@candidate.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/account_candidates", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_candidates/#{@candidate.id}"
      expect(response.status).to eq(401)
    end
  end

  context 'when logged out' do

    before(:each) do
      @account = FactoryGirl.create(:account1)
      @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r', user_id: FactoryGirl.create(:user_account_user, account: @account).id
    end

    it 'should return 401 on collection' do
      get "/api/v1/account_candidates", account_id: @account.slug
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show' do
      get "/api/v1/account_candidates/#{@candidate.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create' do
      post "/api/v1/account_candidates", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_candidates/#{@candidate.id}"
      expect(response.status).to eq(401)
    end
  end
end
