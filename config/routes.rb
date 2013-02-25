RedmineApp::Application.routes.draw do
  resources :checkpoints, :path_prefix => '/projects/:project_id/metrics' do
    :member do
      post :new_journal
      post :edit_journal
      get :edit_journal
    end
    put :preview, :on => :collection
  end

  resources :expenditures, :path_prefix => '/projects/:project_id/metrics' do
    :member do
      post :new_journal
      post :edit_journal
      get :edit_journal
    end
    put :preview, :on => :collection
  end

  match '/projects/:project_id/metrics/:action', :controller => 'metrics', :as => :metrics
  match '/management/:action', :controller => 'management', :as => :management
  match '/admin/cost_history', :controller => 'admin', :action => 'cost_history', :as => :cost_history
end
