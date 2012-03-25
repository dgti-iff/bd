class RelatoriosController < InheritedResources::Base
  actions :new, :create, :show, :edit, :update, :aprovar, :submeter

  include NovoComAutor
  include WorkflowActions
  include ContadorDeAcesso
  include Favoritar

  before_filter :authenticate_usuario!
  before_filter :pode_editar, only: [:edit, :update]
  load_and_authorize_resource

  def show
    incrementar_numero_de_acessos
  end
end

