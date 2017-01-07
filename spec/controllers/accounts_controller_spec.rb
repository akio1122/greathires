require "spec_helper"

include Warden::Test::Helpers


describe AccountsController do

  before do
    @route_helpers = Rails.application.routes.url_helpers

    load "#{Rails.root}/db/seeds.rb"

    @template_account = Account.first
  end

  context "sysadmin abilities" do
    before(:each) do
      @user = FactoryGirl.create(:user_sysadmin)
      login_as @user, scope: :user
    end

    it 'sysadmin has access to manage_account' do
      visit @route_helpers.new_account_path
      page.has_content?('Set Up a New Customer Account')
    end

    it 'sysadmin has access to job spec page' do
      visit @route_helpers.setup_account_manage_account_index_path(@template_account)
      page.has_content?('Job Specification')
    end

    it 'sysadmin has access to interview rounds page' do
      visit @route_helpers.interview_rounds_account_manage_account_index_path(@template_account)
      page.has_content?('Interview Rounds')
      page.should have_css("ul.interview_rounds li", count: @template_account.interview_rounds.count)
    end

    it 'sysadmin has access to interview guide page' do
      visit @route_helpers.interview_guides_account_manage_account_index_path(@template_account)
      page.has_content?('Interview Guide')

      find(:css, "#account_interview_guide_is_available").set(true)
      fill_in "account_interview_guide_label", with: 'Competencies'
      find(:css, "#account_interview_guide_enable_question_field").set(true)

      find_button('Done').click

      @template_account.reload

      @template_account.interview_guide[:label].should == 'Competencies'
      @template_account.interview_guide[:is_available].should == '1'
      @template_account.interview_guide[:enable_question_field].should == '1'
    end

    it 'sysadmin has access to prepare page' do
      visit @route_helpers.prepare_account_manage_account_index_path(@template_account)
      page.has_content?('Prepare')
    end

    it 'sysadmin has access to interview page' do
      visit @route_helpers.interview_account_manage_account_index_path(@template_account)
      page.has_content?('Candidate Priorities')
    end

    it 'sysadmin has access to evaluate page' do
      visit @route_helpers.evaluate_account_manage_account_index_path(@template_account)
      page.has_content?('Evaluate')
    end

    it 'sysadmin has access to Candidate Status page' do
      visit @route_helpers.candidate_statuses_account_manage_account_index_path(@template_account)
      page.has_content?('Candidate Status')
      page.has_content?('Interviewing State')
    end

    it 'sysadmin has access to create account' do
      visit @route_helpers.new_account_path

      within(".account_set_up") do
        fill_in 'account_company_name', with: 'Lorem'
        fill_in 'email_domain', with: 'lorem.com'
      end

      expect {
        find_button('Done').click
      }.to change{ Account.count }

      account = Account.last

      # check business_units
      account.business_units.count.should == 1
      account.business_units.first.name.should == @template_account.business_units.first.name

      # check functions
      account.functions.first.name.should == @template_account.functions.first.name
      account.functions.last.name.should == @template_account.functions.last.name

      # check positions
      account.positions.last.name.should == @template_account.positions.last.name

      # check levels
      account.levels.last.name.should == @template_account.levels.last.name

      # check roles
      account.roles.last.name.should == @template_account.roles.last.name

      # check skills
      account.skills.first.name.should == @template_account.skills.first.name

      # check interview_rounds
      account.interview_rounds.first.name.should == @template_account.interview_rounds.first.name

      # check preferences
      account.preferences.should == @template_account.preferences
    end

  end

  # context "normal user abilities" do
  #   before(:each) do
  #     @user = FactoryGirl.create(:user)
  #     login_as @user, scope: :user
  #   end

  #   it 'normal user has no access to manage_account' do
  #     visit @route_helpers.new_account_path
  #     page.has_no_content?('Set Up a New Customer Account')
  #   end

  #   it 'normal user has no access to job spec page' do
  #     visit @route_helpers.job_specifications_account_path(@template_account)
  #     page.has_no_content?('Job Specification')
  #   end

  #   it 'normal user has no access to interview rounds page' do
  #     visit @route_helpers.interview_rounds_account_path(@template_account)
  #     page.has_no_content?('Interview Rounds')
  #     page.should have_css("ul.interview_rounds li", count: @template_account.interview_rounds.count)
  #   end

  #   it 'normal user has no access to interview guide page' do
  #     visit @route_helpers.interview_guides_account_path(@template_account)
  #     page.has_no_content?('Interview Guide')
  #   end

  #   it 'normal user has no access to prepare page' do
  #     visit @route_helpers.prepare_account_path(@template_account)
  #     page.has_no_content?('Prepare')
  #   end

  #   it 'normal user has no access to interview page' do
  #     visit @route_helpers.interview_account_path(@template_account)
  #     page.has_no_content?('Candidate Priorities')
  #   end

  #   it 'normal user has no access to evaluate page' do
  #     visit @route_helpers.evaluate_account_path(@template_account)
  #     page.has_no_content?('Evaluate')
  #   end

  #   it 'normal user has no access to Candidate Status page' do
  #     visit @route_helpers.candidate_statuses_account_path(@template_account)
  #     page.has_no_content?('Candidate Status')
  #     page.has_no_content?('Interviewing State')
  #   end
  # end
end
