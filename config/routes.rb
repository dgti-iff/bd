DigitalLibrary::Application.routes.draw do
  resources :formulario_contato, only: [:new, :create]

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :usuarios, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
                        controllers: {registrations: 'registrations'}
  resources :usuarios, only: [:index] do
    collection do
      put :atualizar_papeis
      get :buscar_por_nome
      get :usuarios_instituicao
      get :papeis
    end

    member do
      get :lista_de_revisao
      get :escrivaninha
      get :estante
      get :minhas_buscas
      get :area_privada
      get "/minhas_buscas/mala_direta", to: "buscas#mala_direta", as: :mala_direta
    end
  end

  root :to => 'pages#inicio'

  get   "/areas/:area_id/conteudos", to: "conteudos#por_area", as: :conteudos_por_area
  get   "/sub_area/:sub_area_id/conteudos", to: "conteudos#por_sub_area", as: :conteudos_por_sub_area
  match "/ajuda",     :to => "pages#ajuda", via: :get
  match "/ajuda/manuais", :to => "pages#manuais", via: :get
  match "/sobre",     :to => "pages#sobre", via: :get
  match "/converter_video", :to =>"pages#converter_video", via: :get
  match '/adicionar_conteudo', :to => 'pages#adicionar_conteudo', via: :get
  match '/estatisticas', :to => "pages#estatisticas", via: :get
  match '/por_conteudo_individual', :to => "pages#por_conteudo_individual", via: :get
  match '/por_tipo_de_conteudo', :to => "pages#por_tipo_de_conteudo", via: :get
  match '/por_subarea_do_conhecimento', :to => "pages#por_subarea_do_conhecimento", via: :get
  match '/documentos_mais_acessados', :to => 'pages#documentos_mais_acessados', via: :get
  match '/mapa_do_site', :to => 'pages#mapa_do_site', via: :get
  match '/acessibilidade', :to => 'pages#acessibilidade', via: :get
  resources :buscas do
    post :cadastrar_mala_direta, :to => 'buscas#cadastrar_mala_direta'
    post :remover_mala_direta, :to => 'buscas#remover_mala_direta'
  end

  resources :buscas_por_imagem, only: [:new, :create]

  get :busca_avancada, to: 'buscas#busca_avancada'
  get :busca_normal, to: 'buscas#busca_normal'
  get :busca_pronatec, to: 'buscas#busca_pronatec'
  get :buscar_pronatec, to: 'buscas#buscar_pronatec'

  resources :tutoriais, :only => :index, :path => '/ajuda/tutoriais'
  match 'ajuda/tutoriais/*tutorial' => 'tutoriais#show', :via => :get

  resources :conteudos, except: [:index] do
    member do
      put :recolher
      put :aprovar
      put :pre_submeter
      put :submeter
      put :favoritar
      put :remover_favorito
      put :devolver
      put :retornar_para_revisao
    end
    post :granularizou, on: :collection
    get "/baixar_conteudo" , :to => 'conteudos#baixar_conteudo'
  end

  resources :graos, :except => :all  do
    member do
      put :adicionar_a_cesta
      delete :remover_da_cesta
      put :favoritar
    end
    collection do
      get :cesta
      post :editar
    end
    get "/baixar_grao" , :to => 'graos#baixar_grao'
    get :limpar_cesta, on: :collection if Rails.env.test?
  end

  get :favoritar_graos, :to => 'graos#favoritar_graos'
  get "/cesta/baixar_conteudo", :to => 'graos#baixar_conteudo'
  get "/cesta/baixar_conteudo_em_odt", :to => 'graos#baixar_conteudo_em_odt'

  match "/areas/:id/sub_areas" => "areas#sub_areas", via: :get
  match "/instituicoes/:id/campus" => "instituicoes#campus", via: :get
  match "/eixos_tematicos/:id/cursos" => "eixos_tematicos#cursos", via: :get
  get '/editor' => 'editor#index', as: :editor
  post '/editor' => 'editor#download'

  match '*path' => 'application#routing_error' unless Rails.application.config.consider_all_requests_local
end
