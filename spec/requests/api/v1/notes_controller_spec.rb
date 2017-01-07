require "spec_helper"

describe Api::V1::NotesController, group: :api do

  context 'when logged in' do

    before(:each) do
      class Job < ActiveRecord::Base
        def add_default_job_manager; end
      end
      @account = FactoryGirl.create(:account1)
      @job = FactoryGirl.create :job, account_id: @account.id
      
      @user_hiring_manager =  FactoryGirl.create(:user_hiring_manager, account: @account, job: @job)

      @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r'
      @job_candidate = JobCandidate.create job: @job, candidate: @candidate
      @note = FactoryGirl.create :note, job_candidate: @job_candidate, kind: 'hr'
      login_as @user_hiring_manager
    end

    it 'should return note on show' do
      get "/api/v1/notes/#{@note.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@note.id)
    end

    it 'should not create note without text' do
      expect {
        post "/api/v1/notes", job_candidate_id: @job_candidate.id
        expect(response.status).to eq(422)
      }.not_to change{Note.count}.by(1)
    end

    it 'should create note' do
      expect {
        post "/api/v1/notes", job_candidate_id: @job_candidate.id, text: Faker::Lorem.sentence, kind: 'hr'
        expect(response).to be_success
      }.to change{Note.count}.by(1)
    end

  end

  context 'when logged out' do
    before(:each) do
      class Job < ActiveRecord::Base
        def add_default_job_manager; end
      end
      @account = FactoryGirl.create(:account1)
      @job = FactoryGirl.create :job, account_id: @account.id,
                                    function_id: @account.functions.first.id,
                                    level_id: @account.levels.first.id,
                                    position_id: @account.positions.first.id
      @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r'
      @job_candidate = JobCandidate.create job: @job, candidate: @candidate
      @note = FactoryGirl.create :note, job_candidate: @job_candidate, kind: 'hr'
     end

    it 'should return 401 on show note' do
      get "/api/v1/notes/#{@note.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create note' do
      post "/api/v1/notes", job_candidate_id: @job_candidate.id, text: Faker::Lorem.sentence, kind: 'hr'
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before(:each) do
      class Job < ActiveRecord::Base
        def add_default_job_manager; end
      end
      @user = FactoryGirl.create(:user)
      @account = FactoryGirl.create(:account1)
      @job = FactoryGirl.create :job, account_id: @account.id,
                                    function_id: @account.functions.first.id,
                                    level_id: @account.levels.first.id,
                                    position_id: @account.positions.first.id

      @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r'
      @job_candidate = JobCandidate.create job: @job, candidate: @candidate
      @note = FactoryGirl.create :note, job_candidate: @job_candidate, kind: 'hr'
      login_as @user
    end

    it 'should return 401 on show note' do
      get "/api/v1/notes/#{@note.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create note' do
      post "/api/v1/notes", job_candidate_id: @job_candidate.id, text: Faker::Lorem.sentence, kind: 'hr'
      expect(response.status).to eq(401)
    end

  end

end