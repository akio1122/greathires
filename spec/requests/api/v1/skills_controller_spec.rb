require "spec_helper"

describe Api::V1::SkillsController, group: :api do
  
  before do
    @account = FactoryGirl.create(:account1)
    @skill = @account.skills.first
  end

  context 'when logged in' do
  
    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end
  
    it 'should return collection' do
      get "/api/v1/account_skills", account_id: @account.slug
      expect(response).to be_success
      expect(json[0]['name']).to eq('Teamwork')
    end
  
    it 'should return skill' do
      get "/api/v1/account_skills/#{@skill.id}"
      expect(response).to be_success
      expect(json['name']).to eq('Teamwork')
    end
  
    it 'should create skill' do
      post "/api/v1/account_skills", account_id: @account.slug, name: 'Lorem'
      expect(response).to be_success
      expect(json['name']).to eq('Lorem')
    end
  
    it 'should return validation errors' do
      post "/api/v1/account_skills", account_id: @account.slug, name: ''
      expect(response.status).to eq(422)
      expect(json['errors']).to eq(["Name is required"])
    end

    it 'should update skill' do
      put "/api/v1/account_skills/#{@skill.id}", name: 'blabla'
      expect(response).to be_success
      expect(json['name']).to eq('blabla')
    end

    it 'should destroy skill' do
      expect {
        delete "/api/v1/account_skills/#{@skill.id}"
        expect(response).to be_success
      }.to change{AccountSkill.count}.by(-1)
    end

  end

  context 'when logged out' do
  
    it 'should return 401 on collection' do
      get "/api/v1/account_skills", account_id: @account.slug
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show' do
      get "/api/v1/account_skills/#{@skill.id}"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create' do
      post "/api/v1/account_skills", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_skills/#{@skill.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_skills/#{@skill.id}"
      expect(response.status).to eq(401)
    end
  
  end
  
  context 'when logged in but without permission' do
  
    before do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end
  
    it 'should return 401 on collection' do
      get "/api/v1/account_skills", account_id: @account.slug
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show' do
      get "/api/v1/account_skills/#{@skill.id}"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create' do
      post "/api/v1/account_skills", account_id: @account.slug, name: 'Lorem'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/account_skills/#{@skill.id}", name: 'blabla'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on delete' do
      delete "/api/v1/account_skills/#{@skill.id}"
      expect(response.status).to eq(401)
    end
  
  end

end
