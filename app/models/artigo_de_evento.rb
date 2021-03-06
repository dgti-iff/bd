# encoding: utf-8

class ArtigoDeEvento < Conteudo
  index_name 'conteudos'

  validate :verificar_paginas
  validate :verificar_ano

  validates :numero_evento, :ano_evento, :ano_publicacao,
            :pagina_final, :pagina_inicial, :numero_edicao,
            numericality: { greater_than: 0, allow_blank: true }

  def self.nome_humanizado
    'Artigo de Evento'
  end

  def permite_extracao_de_metadados?
    true
  end

  private

  def verificar_paginas
    if !pagina_inicial.blank? and pagina_final < pagina_inicial
      errors.add(:pagina_final, "Página final deve ser maior que página inicial")
    end
  end

  def verificar_ano
    if !ano_publicacao.blank? and (ano_publicacao < 1990 or ano_publicacao > Time.now.year)
      errors.add(:ano_publicacao, "Insira um ano válido")
    end
  end
end
