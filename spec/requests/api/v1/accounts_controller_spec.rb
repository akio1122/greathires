require "spec_helper"

describe Api::V1::AccountsController, group: :api do
  
  before do
    @account = FactoryGirl.create(:account1)
  end

  context 'when logged in as admin' do
  
    before do
      @user =  FactoryGirl.create(:user_sysadmin)
      login_as @user
    end
  
    it 'should return collection' do
      get "/api/v1/accounts"
      expect(response).to be_success
      expect(json[0]['company_name']).to eq('Account 1')
    end
  
    it 'should create account' do
      expect {
        post "/api/v1/accounts", company_name: 'XXX', email_domain: 'yyy.com'
        expect(response).to be_success
      }.to change{Account.count}.by(1)
    end

  end

  context 'when logged in as account manager' do
  
    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end
  
    it 'should return 401 on collection' do
      get "/api/v1/accounts"
      expect(response.status).to eq(401)
    end
  
    it 'should return account' do
      get "/api/v1/accounts/#{@account.id}"
      expect(response).to be_success
      expect(json['company_name']).to eq('Account 1')
    end
  
    it 'should return 401 on create account' do
      post "/api/v1/accounts", company_name: 'XXX', company_email: 'xxx@yyy.com'
      expect(response.status).to eq(401)
    end
  
    it 'should update account' do
      
      put "/api/v1/accounts/#{@account.id}", {
        # bool values
        interviewer_notes_enabled: false,
        display_linked_in: true,
        preferred_candidate_enabled: true,
        overall_comments_enabled: true,
        job_video_urls_enabled: true,
        job_spec_questions_numbered: true,
        job_spec_questions_ratable: true,
        job_spec_questions_enabled: true,
        job_spec_sub_items_enabled: true,
        personalized_interview_guides_enabled: true,
        job_skill_traits_ratable: true,
        job_skill_sub_traits_enabled: true,
        job_skill_questions_ratable: true,
        job_skill_questions_enabled: true,
        job_skill_questions_numbered: true,
        job_skill_questions_comments_enabled: true,
        # string values
        company_name: 'XXX<b>a</b>',
        company_email: 'zzz@aaa.com<b>a</b>',
        preferred_candidate_label: 'a<b>a</b>',
        overall_questions_title: 'b<b>a</b>',
        overall_comments_label: 'c<b>a</b>',
        overall_comments_message: 'd<b>a</b>',
        view_job_skills_comments_message: 'e<b>a</b>',
        job_skills_label: 'f<b>a</b>'},
        {format: :json}
      expect(response).to be_success
      expect(json['company_name']).to eq('XXXa')
      expect(json['company_email']).to eq('zzz@aaa.coma')
      expect(json['preferred_candidate_label']).to eq('aa')
      expect(json['overall_questions_title']).to eq('ba')
      expect(json['overall_comments_label']).to eq('ca')
      expect(json['overall_comments_message']).to eq('da')
      expect(json['view_job_skills_comments_message']).to eq('ea')
      expect(json['job_skills_label']).to eq('fa')
      expect(json['interviewer_notes_enabled']).to eq(false)
      expect(json['display_linked_in']).to eq(true)
      expect(json['preferred_candidate_enabled']).to eq(true)
      expect(json['overall_comments_enabled']).to eq(true)
      expect(json['job_video_urls_enabled']).to eq(true)
      expect(json['job_spec_questions_numbered']).to eq(true)
      expect(json['job_spec_questions_ratable']).to eq(true)
      expect(json['job_spec_questions_enabled']).to eq(true)
      expect(json['job_spec_sub_items_enabled']).to eq(true)
      expect(json['personalized_interview_guides_enabled']).to eq(true)
      expect(json['job_skill_traits_ratable']).to eq(true)
      expect(json['job_skill_sub_traits_enabled']).to eq(true)
      expect(json['job_skill_questions_ratable']).to eq(true)
      expect(json['job_skill_questions_enabled']).to eq(true)
      expect(json['job_skill_questions_numbered']).to eq(true)
      expect(json['job_skill_questions_comments_enabled']).to eq(true)
    end

    it 'should return validation errors' do
      put "/api/v1/accounts/#{@account.id}", company_name: ''
      expect(response.status).to eq(422)
      expect(json['errors']).to eq(["Company name can't be blank"])
    end

  end

  context 'when logged out' do
  
    it 'should return 401 on collection' do
      get "/api/v1/accounts"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show' do
      get "/api/v1/accounts/#{@account.id}"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create' do
      post "/api/v1/accounts"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/accounts/#{@account.id}"
      expect(response.status).to eq(401)
    end

  end
  
  context 'when logged in but without permission' do
  
    before do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end
  
    it 'should return 401 on collection' do
      get "/api/v1/accounts"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show' do
      get "/api/v1/accounts/#{@account.id}"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create' do
      post "/api/v1/accounts"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on update' do
      put "/api/v1/accounts/#{@account.id}"
      expect(response.status).to eq(401)
    end
  
  end

end
