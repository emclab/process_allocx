Rails.application.routes.draw do

  mount ProcessAllocx::Engine => "/process_allocx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount MachineToolx::Engine => '/machine_tool'
  mount MfgBatchx::Engine => '/batch'
  mount Searchx::Engine => '/search'
  mount JobshopRfqx::Engine => '/rfq'
  mount Kustomerx::Engine => '/customer'
  mount MfgOrderx::Engine => '/order'
  mount JobshopQuotex::Engine => '/quote'
  mount EventTaskx::Engine => '/task'
  mount BizWorkflowx::Engine => '/wf'
  mount StateMachineLogx::Engine => 'sm_log'
  mount MfgProcessx::Engine => 'mfg_process'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
