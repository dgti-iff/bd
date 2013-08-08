# encoding: utf-8

require 'spec_helper'

describe Estatistica do
  it 'deve retornar usuários cadastrados por ano' do
    ano_atual = Date.today.year
    Timecop.travel(2.years.ago) do
      3.times { create(:usuario) }
    end
    Timecop.travel(1.year.ago) do
      4.times { create(:usuario) }
    end
    2.times { create(:usuario) }

    estatisticas =  Estatistica.new(ano_atual)
    estatisticas.numero_de_usuarios_cadastrados.should == 2

    estatisticas = Estatistica.new(ano_atual - 2)
    estatisticas.numero_de_usuarios_cadastrados.should == 3

    estatisticas = Estatistica.new(ano_atual - 1)
    estatisticas.numero_de_usuarios_cadastrados.should == 4
  end

  it 'deve retornar usuários cadastrados por mês' do
    Timecop.travel(2.months.ago) do
      4.times { create(:usuario) }
    end
    Timecop.travel(10.months.ago) do
      9.times { create(:usuario) }
    end

    estatisticas =  Estatistica.new(2.months.ago.year, 2.months.ago.month)
    estatisticas.numero_de_usuarios_cadastrados.should == 4
  end

  it 'deve retornar os cinco documentos mais acessados' do
    livro = create(:livro, :numero_de_acessos => 10)
    livro.save!
    periodico = create(:periodico_tecnico_cientifico, :numero_de_acessos => 8)
    periodico.save!
    artigo_de_evento = create(:artigo_de_evento, :numero_de_acessos => 5)
    artigo_de_evento.save!
    relatorio = create(:relatorio, :numero_de_acessos => 3)
    relatorio.save!
    trabalho_obtencao_de_grau = create(:trabalho_de_obtencao_de_grau, :numero_de_acessos => 2)
    trabalho_obtencao_de_grau.save!
    estatisticas = Estatistica.new(Date.today.year)
    estatisticas.cinco_documentos_mais_acessados.length.should_not > 5
  end

  it 'deve retornar todos os documentos mais acessados' do
    livro = create(:livro, :numero_de_acessos => 12, :state => 'publicado')
    livro.save!
    periodico = create(:periodico_tecnico_cientifico, :numero_de_acessos => 10, :state => 'publicado')
    periodico.save!
    artigo_de_evento = create(:artigo_de_evento, :numero_de_acessos => 8, :state => 'publicado')
    artigo_de_evento.save!
    relatorio = create(:relatorio, :numero_de_acessos => 5, :state => 'publicado')
    relatorio.save!
    trabalho_obtencao_de_grau = create(:trabalho_de_obtencao_de_grau, :numero_de_acessos => 4, :state => 'publicado')
    trabalho_obtencao_de_grau.save!
    objeto_de_aprendizagem = create(:objeto_de_aprendizagem, :numero_de_acessos => 3, :state => 'publicado')
    objeto_de_aprendizagem.save!
    artigo_de_periodico = create(:artigo_de_periodico, :numero_de_acessos => 2, :state => 'publicado')
    artigo_de_periodico.save!
    estatisticas = Estatistica.new(Date.today.year)
    estatisticas.documentos_mais_acessados.length.should ==  7
  end

  it 'deve retornar o percentual dos acessos por tipo de conteúdo' do
    artigo_de_evento = create(:artigo_de_evento, :numero_de_acessos => 7, :state => 'publicado')
    artigo_de_evento.save!
    artigo_de_periodico = create(:artigo_de_periodico, :numero_de_acessos => 7, :state => 'publicado')
    artigo_de_periodico.save!
    livro = create(:livro, :numero_de_acessos => 7, :state => 'publicado')
    livro.save!
    objeto_de_aprendizagem = create(:objeto_de_aprendizagem, :numero_de_acessos => 7, :state => 'publicado')
    objeto_de_aprendizagem.save!
    periodico = create(:periodico_tecnico_cientifico, :numero_de_acessos => 14, :state => 'publicado')
    periodico.save!
    relatorio = create(:relatorio, :numero_de_acessos => 21, :state => 'publicado')
    relatorio.save!
    trabalho_obtencao_de_grau = create(:trabalho_de_obtencao_de_grau, :numero_de_acessos => 7, :state => 'publicado')
    trabalho_obtencao_de_grau.save!
    estatisticas = Estatistica.new(Date.today.year)
    estatisticas.percentual_de_acessos_por_tipo_de_conteudo.should == [["Artigo de evento", 10.0],
                                                                       ["Artigo de periodico", 10.0],
                                                                       ["Livro", 10.0], 
                                                                       ["Objeto de aprendizagem", 10.0], 
                                                                       ["Periodico tecnico cientifico", 20.0],
                                                                       ["Relatorio", 30.0],
                                                                       ["Trabalho de obtencao de grau", 10.0]]
  end

  it 'deve retornar as cinco sub areas com maior percentual de acesso' do
    artigo_de_evento = create(:artigo_de_evento, :numero_de_acessos => 7)
    artigo_de_evento.save!
    artigo_de_periodico = create(:artigo_de_periodico, :numero_de_acessos => 7)
    artigo_de_periodico.save!
    livro = create(:livro, :numero_de_acessos => 7)
    livro.save!
    objeto_de_aprendizagem = create(:objeto_de_aprendizagem, :numero_de_acessos => 7)
    objeto_de_aprendizagem.save!
    periodico = create(:periodico_tecnico_cientifico, :numero_de_acessos => 14)
    periodico.save!
    estatisticas = Estatistica.new(Date.today.year)
    estatisticas.cinco_maiores_percentuais_de_acessos_por_subarea == [
                         [10.0, SubArea.find(artigo_de_evento.sub_area_id).nome],
                         [10.0, SubArea.find(artigo_de_periodico.sub_area_id).nome],
                         [10.0, SubArea.find(livro.sub_area_id).nome],
                         [10.0, SubArea.find(objeto_de_aprendizagem.sub_area_id).nome],
                         [20.0, SubArea.find(periodico.sub_area_id).nome]]
  end

  it 'deve retornar as cinco instituições com maior número de contribuições em um período de tempo' do
    instituicao1 = create(:instituicao, nome: "IFF")
    instituicao2 = create(:instituicao, nome: "IFRN")

    campus1 = create(:campus, instituicao: instituicao1)
    campus2 = create(:campus, instituicao: instituicao2)

    artigo_de_evento = create(:artigo_de_evento,
                                      :state => 'publicado',
                                      :campus => campus1)
    livro = create(:livro,
                           :state => 'publicado',
                           :campus => campus1)
    objeto_de_aprendizagem = create(:objeto_de_aprendizagem,
                                            :state => 'publicado',
                                            :campus => campus1)

    estatisticas = Estatistica.new(Date.today.year, Date.today.month)
    estatisticas.instituicoes_contribuidoras.should == [
                         [3, "IFF"]]
  end

  it 'deve retornar os cinco campus com maior número de contribuições em um período de tempo' do
    instituicao1 = create(:instituicao, nome: "IFF")
    instituicao2 = create(:instituicao, nome: "IFRN")

    campus1 = create(:campus, nome: "Centro", instituicao: instituicao1)
    campus2 = create(:campus, nome: "Guarus", instituicao: instituicao2)

    periodico = create(:periodico_tecnico_cientifico,
                               :state => 'publicado',
                               :campus => campus2)
    relatorio = create(:relatorio,
                               :state => 'publicado',
                               :campus => campus1)
    trabalho_obtencao_de_grau = create(:trabalho_de_obtencao_de_grau,
                                               :numero_de_acessos => 7,
                                               :state => 'publicado',
                                               :campus => campus2)

    estatisticas = Estatistica.new(Date.today.year, Date.today.month)
    estatisticas.campus_contribuidores.should == [
                         [2, "Guarus"],
                         [1, "Centro"]]
  end
end
