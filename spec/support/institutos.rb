# encoding: utf-8

def campus_nao_federais
  nenhum_instituto = Instituicao.create(nome: 'Não pertenço a uma Instituição da Rede Federal de EPCT')
  nenhum_instituto.campi.create(nome: '----')

  [nenhum_instituto.campi]
end
