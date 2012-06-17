# encoding: utf-8

require 'spec_helper'

feature 'apresentar breadcrumbs para' do
  before(:each) do
    Papel.criar_todos
    @usuario = autenticar_usuario(Papel.admin)
  end

  scenario 'home' do
    verificar_breadcrumbs root_path, 'Início'
  end

  context 'usuários' do
    let(:crumb_usuarios) { 'Usuários » ' }

    scenario 'index' do
      verificar_breadcrumbs usuarios_path, 'Usuários'
    end

    scenario 'busca por nome' do
      verificar_breadcrumbs(
        buscar_por_nome_usuarios_path, crumb_usuarios + 'Busca por nome')
    end

    scenario 'papéis' do
      verificar_breadcrumbs(
        papeis_usuarios_path, crumb_usuarios + 'Papéis')
    end

    scenario 'área privada' do
      verificar_breadcrumbs(
        area_privada_usuario_path(@usuario), crumb_usuarios + 'Área privada')
    end

    scenario 'minhas buscas' do
      verificar_breadcrumbs(
        minhas_buscas_usuario_path(@usuario), crumb_usuarios + 'Minhas buscas')
    end
  end
end
