# encoding: utf-8

require 'spec_helper'

feature 'submeter conteúdo a aprovação' do
  before (:each) do
    Papel.criar_todos
    popular_area_sub_area
    popular_eixos_tematicos_cursos
  end

  let(:user) { autenticar_usuario(Papel.contribuidor) }

  tipos_de_conteudo.each do |tipo|
    scenario "dono do #{tipo} pode submetê-lo a aprovação" do
      conteudo = create(tipo, contribuidor: user)

      visit conteudo_path(conteudo)
      click_button 'Submeter'
      if conteudo.permite_extracao_de_metadados?
        current_path.should == pre_submeter_conteudo_path(conteudo)
        click_button 'O conteúdo foi revisado!'
      else
        current_path.should == conteudo_path(conteudo)
      end
      visit conteudo_path(conteudo)

      page.should_not have_content 'Submeter'
      within '#escrivaninha' do
        page.should have_content conteudo.titulo
      end
    end
  end
end
