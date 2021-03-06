#encoding: utf-8

require 'spec_helper'

describe "portlets/_lista_de_revisao.html.haml" do
  let(:usuario) { stub_model(Usuario, lista_de_revisao: []) }

  before :each do
    view.stub(:current_usuario).and_return(usuario)
  end

  it 'somente é mostrado para usuários com acesso à lista de revisao' do
    view.stub(:can?).with(:ter_lista_de_revisao, usuario).and_return(true)
    render
    rendered.should have_content 'Lista de Revisão'
  end

  it 'nao aparece para usuarios sem acesso' do
    view.stub(:can?).with(:ter_lista_de_revisao, usuario).and_return(false)
    render
    render.should_not have_content 'Lista de Revisão'
  end
  
  it_behaves_like 'a portlet' do
    let(:options) do
      { usuario: stub_model(Usuario, gestor?: true,
        lista_de_revisao: 
          (1..8).map {|n| 
            build(:conteudo, id: n, titulo: "Conteudo #{n}", created_at: Time.now)
          })
      }
    end
  end
end
