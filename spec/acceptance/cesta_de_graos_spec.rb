# encoding: utf-8

require 'spec_helper'
require 'tempfile'

feature 'cesta de grãos' do
  before(:each) do
    Papel.criar_todos
    Tire.criar_indices
    @livro = create(:livro_publicado, titulo: 'Quantum Mechanics for Dummies')

    conteudo_imagem = Base64.encode64(File.open('spec/resources/tela.png').read)
    conteudo_odt = Base64.encode64(File.open('spec/resources/grao_tabela.odt').read)

    result = ServiceRegistry.sam.store file: conteudo_imagem, filename: 'tela.png'
    @grao1 = create(:grao_imagem, conteudo: @livro, key: result.key)

    result = ServiceRegistry.sam.store(file: conteudo_odt, filename: 'grao.odt')
    @grao2 = create(:grao_arquivo, conteudo: @livro, key: result.key)
    Conteudo.tire.index.refresh
  end

  def incluir_grao_na_cesta_pelo_form
    visit grao_path(@grao1)
    click_button 'Adicionar à Cesta de Grãos'

    within('#cesta') { page.should have_content representacao_grao(@grao1) }
    ENV['merda'] = '10'
    visit grao_path(@grao2)
    click_button 'Adicionar à Cesta de Grãos'

    within item_da_cesta(2) do
      page.should have_content representacao_grao(@grao2)
    end
  end

  def incluir_graos_na_cesta
    @usuario.cesta << @grao1.referencia
    @usuario.cesta << @grao2.referencia
  end

  def excluir_grao_da_cesta(options = {})
    visit grao_path(@grao1)
    click_button 'Adicionar à Cesta de Grãos'

    within('#cesta') { page.should have_content representacao_grao(@grao1) }

    visit grao_path(@grao2)
    click_button 'Adicionar à Cesta de Grãos'

    within item_da_cesta(2) do
      page.should have_content representacao_grao(@grao2)
      click_link 'Remover'
    end
    within '#cesta' do
      page.should have_content representacao_grao(@grao1)
      page.should_not have_content representacao_grao(@grao2)
      click_link 'Remover'
      page.should_not have_content representacao_grao(@grao1)
      page.should_not have_content representacao_grao(@grao2)
    end
  end

  def comparar_odt(tag, novo, grao)
    test = open_xml(grao).xpath(tag)
    tmp =  open_xml(novo).xpath(tag)
    test.children.count.should == tmp.children.count
  end

  def open_xml(file)
    doc = ZipFile.open(file)
    Nokogiri::XML(doc.read("content.xml"))
  end

  context 'usuário anônimo' do
    before(:all) do
      class GraosController
        def limpar_cesta
          session[:cesta] = []
          render nothing: true
        end
      end
    end

    after(:all) do
      class GraosController
        undef_method :limpar_cesta
      end
    end

    before :each do
      page.driver.visit limpar_cesta_graos_path
    end

    scenario 'incluir grão na cesta', js: true do
      incluir_grao_na_cesta_pelo_form
    end

    scenario 'excluir grão da cesta', js: true do
      excluir_grao_da_cesta
    end

    scenario 'cesta é zerada em nova sessão', js: true do
      incluir_grao_na_cesta_pelo_form
      page.should have_selector '#cesta.portlet div'
      autenticar_usuario
      deslogar
      page.should_not have_selector '#cesta.portlet div'
    end

    scenario 'grão não pode ser adicionado duas vezes na cesta', js: true do
      incluir_grao_na_cesta_pelo_form
      visit grao_path(@grao2)
      page.should_not have_content 'Adicionar à Cesta de Grãos'
    end

  end

  context 'usuário logado' do
    before :each do
      @usuario = autenticar_usuario(Papel.membro)
    end

    scenario 'incluir grão na cesta', js: true do
      incluir_grao_na_cesta_pelo_form
    end

    scenario 'excluir grão da cesta', js: true do
      excluir_grao_da_cesta
    end

    scenario 'cesta sobrevive de uma sessão para outra', js: true do
      incluir_grao_na_cesta_pelo_form
      visit root_path
      within '#cesta' do
        [@grao1, @grao2].each {|g|
          page.should have_content representacao_grao(g)
        }
      end
      deslogar
      page.should_not have_selector '#items'
      autenticar(@usuario)
      within '#cesta' do
        [@grao1, @grao2].each {|g|
          page.should have_content representacao_grao(g)
        }
      end
    end

    scenario 'editar grão da cesta' do
      criar_cesta @usuario, create(:livro),
                            recurso('grao_teste_0.jpg'),
                            recurso('grao_teste_1.jpg'),
                            recurso('grao_tabela.odt')
      visit root_path
      within('#cesta') { click_link 'Editar' }
      within '#documento' do
        page.should have_selector "img[src^='data:image/xyz;base64']"
        all('table tbody tr').map(&:text).map(&:strip).
        map {|t| t.gsub(/\s+/, ' ') }.
          should == ['1 2 3', '4 5 6', '7 8 9']
      end
    end

    scenario 'baixar conteúdo da cesta' do
      criar_cesta(@usuario, @livro, *%w(./spec/resources/tabela.odt))
      visit root_path
      find('#baixar_conteudo_cesta').click

      page.response_headers['Content-Type'].should == "application/zip"
      file = Tempfile.new('zipfile')
      file.binmode
      file.write(page.source)
      file.close
      begin
        zipped_files = Zip::ZipFile.open(file.path).entries.map(&:name)
        zipped_files.should include "grao_quantum_mechanics_for_dummies_0.odt"
        zipped_files.should include "referencias_ABNT.txt"
      ensure
        file.unlink
      end
    end

    scenario 'baixar conteudo da cesta em odt' do
      criar_cesta(@usuario, @livro, *%w(./spec/resources/tabela.odt
                                        ./spec/resources/biblioteca_digital.png
                                        ./spec/resources/grao_teste_0.jpg))
      visit root_path
      time = Time.now;
      Timecop.freeze(time) do
        find('#baixar_conteudo_cesta_odt').click
        grao_armazenado = "./spec/resources/Linus Torvalds.odt"
        grao_baixado = "#{Rails.root}/tmp/cesta-#{time.getlocal.strftime('%Y-%m-%d_%T')}.odt"
        comparar_odt('//office:text', grao_baixado, grao_armazenado)

        odt = Zip::ZipFile.open(grao_baixado)
        doc = Document.new(odt.read("content.xml"))
        arquivo_odt = doc.to_s
        arquivo_odt.should match @livro.referencia_abnt
        File.delete(grao_baixado)
      end
    end

  end
end
