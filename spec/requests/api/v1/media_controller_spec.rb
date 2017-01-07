require "spec_helper"

describe Api::V1::MediaController, group: :api do

  context 'when logged in' do

    before(:each) do
      @account = FactoryGirl.create(:account)
      @user =  FactoryGirl.create(:user)
      @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r', user_id: @user.id
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @account_manager
    end

    context "when a resume is created" do
      it 'should create candidate' do
        expect {
          post "/api/v1/candidates/#{@candidate.id}/media", resume: {file: '/test/fixtures/resume.txt'}
          expect(response).to be_success
        }.to change{Media.count}.by(1)
      end
    end

  end

end
