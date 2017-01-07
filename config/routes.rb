Interview::Application.routes.draw do

  # Ommiting because this seems totally unnecessary
  #match '/time_zone' => "application#time_zone"

  # These routes are only used if the request is a regular HTML request.  This allows the
  # API controller methods to handle XHR and other direct API calls.
  # Routes to handle routes that have /account/x/ segments

  def view_endpoints
    get 'edit', to: 'accounts#edit'
    resources :interviews
    resources :jobs do
      get :edit
      resources :job_candidates do
        collection do
          get :search
          post :search
        end
        resources :job_interviews, as: :interviews, path: 'interviews'
      end
      member do
        get :navigation
        get :edit
        get :hiring_team
        get :interview_guides
        get 'job_specification_section/:job_specification_section_id', to: 'job#job_specification_section', as: 'job_specification_section'
        get 'job_skill/:job_skill_id', to: 'job#job_skill', as: 'job_skill'
        get :results_summary
        get :candidate_summary
      end
    end
  end

  def api_account_resources
    [
      :candidates,
      :classifications,
      :specifications,
      :skills,
      :statuses,
      :interview_rounds,
      :interview_types,
      :priorities,
      :rating_scales,
      :permissions,
      :role_permissions,
      :jobs,
      :roles
    ].each { |r| resources(r, only: [:index, :show, :create, :update, :destroy]) }

    resources :email_templates, only: [:index, :create, :update, :destroy]
    resources :users, except: [:edit]

    resources :classification_options # FIXME: doesn't load index
    resources :rating_scale_options   # FIXME: doesn't load index
    resources :user_roles             # FIXME: doesn't load index
    resources :invitations do         # FIXME: doesn't load index
      collection do
        get :invite # TODO: doesn't load either
      end
    end
  end

  def api_job_resources
    concern :mediable do
      resources :media, only:[:create, :update]
      resource :s3_signature, only: [:create, :show]
    end

    concern :ratable do
      resources :job_candidate_ratings, only: [:index, :show, :create, :update, :destroy]
    end

    [
      :job_candidate_ratings,
      :job_classifications
    ].each { |r| resources(r, only: [:index, :show, :create, :update, :destroy]) }

    resources :job_candidates,  only: [:index, :show, :create, :update, :destroy], concerns: :mediable

    resources :job_interviews, only: [:index, :show, :create, :update, :destroy], concerns: :ratable

    resources :job_specifications do # FIXME doesn't load index, didn't test further down
      resources :job_specification_items, only: [:index, :show, :create, :update, :destroy], concerns: :ratable
      resources :job_specification_questions, only: [:index, :show, :create, :update, :destroy], concerns: :ratable
    end

    resources :job_skills, only: [:index, :show, :create] do
      resources :job_skill_questions, only: [:index, :show, :create, :update, :destroy], concerns: :ratable # FIXME: doesn't load index
      resources :job_skill_traits, only: [:index, :show, :create, :update, :destroy], concerns: :ratable    # FIXME: doesn't load index
    end

    resources :job_roles            # FIXME: doesn't load index
    resources :job_interview_guides # FIXME: doesn't load index
  end


  scope constraints: lambda {|r| r.format==:html} do
    # Put Routes for authentication outside of scope for vanity/non-vanity routing
    # as Devise routes shouldn't be scoped according to account.
    # Devise routes should handling only HTML based requests
    devise_for :users,
                       path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'sign_up'},
                       controllers: { sessions: 'devise/sessions',
                                       registrations: 'users/registrations',
                                       invitations: 'users/invitations',
                                       passwords: 'devise/passwords',
                                       omniauth_callbacks: 'omniauth_callbacks'
                                     } do
                  # get "/login?account=:account_name", :to => "devise/sessions#new", :as => "login" # Add a custom sign in route for user sign in
                  #get "/disconnect_linkedin/:user_id" => "users/omniauth_callbacks#disconnect_linkedin", :as => "disconnect_linkedin"
                  unauthenticated :user do
                    root :to => 'devise/sessions#new'
                  end
                end

    # Route user to dashboard controller for ultimate redirecting.
    root :to => 'dashboard#index'

    ## Routes for NON-vanity domains, for urls like: www.greathires.co/account/{account.slug}/some_path
    scope constraints: lambda {|r| Rails.application.config.non_vanity_subdomains.include?(r.subdomain) || !r.subdomain.present?} do
      resources :accounts, defaults: {format: :html} do
        view_endpoints
      end
    end

    ## Routes for vanity domains, for urls like: intuit.greathires.co/some_path
    scope constraints: lambda { |r| r.subdomain.present? && !Rails.application.config.non_vanity_subdomains.include?(r.subdomain) } do
      view_endpoints
    end
  end

  api_version module: "Api::V1", path: {value: "api/v1"}, default: true do # constraints: OnlyAjaxRequest.new,
    # Load account related resources this way so they can be accessed directly with account_id as qs_param or in url (see nesting below)
    api_account_resources
    api_job_resources

    # Mount account resources under accounts path for more RESTful URL construction.
    resources :accounts do
      api_account_resources
    end

    # Mount job resources under accounts path for more RESTful URL construction.
    resources :jobs do
      api_job_resources
    end

    resources :linkedin
    resources :users, except: [:edit]

  end

end
