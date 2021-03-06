# encoding: utf-8
require 'base64'

def item_da_cesta(n)
  "#cesta.portlet div:nth-child(%s)" % (n.to_i + 1).to_s
end

def criar_cesta(usuario, conteudo, *grain_files)
  sam = ServiceRegistry.sam
  grain_files.each_with_index do |file, index|
    tipo_grao = file.downcase.end_with?('odt') ? :grao_arquivo : :grao_imagem
    extensao = tipo_grao == :grao_arquivo ? "odt" : "png"
    result = sam.store('file' => Base64.encode64(File.read(file)), 'filename' => "filename_#{index}.#{extensao}")
    sleep(1)
    grao = create(tipo_grao, key: result.key, conteudo: conteudo)
    usuario.cesta << grao.referencia
  end
  usuario.cesta
end

def representacao_grao(grao)
  "#{grao.conteudo.titulo}_#{grao.tipo_humanizado}_#{grao.id}"
end
