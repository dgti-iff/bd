# encoding: utf-8

require 'spec_helper'

describe Grao do
  it 'responde se é do tipo arquivo' do
    build(:grao_arquivo).should be_arquivo
    Grao.new(tipo: 'outra coisa').should_not be_arquivo
  end

  it 'responde se é do tipo imagem' do
    build(:grao_imagem).should be_imagem
    Grao.new(tipo: 'outra coisa').should_not be_imagem
  end

  it 'informa seu tipo de modo humanizado' do
    build(:grao_imagem).tipo_humanizado.should == 'imagem'
    build(:grao_arquivo).tipo_humanizado.should == 'arquivo'
    Grao.new(tipo: 'outra coisa').tipo_humanizado.should be_nil
  end

  it 'possui metodo referencia_abnt referenciando seu conteudo' do
    conteudo = create(:livro)
    conteudo.should_receive(:referencia_abnt).and_return('referencia abnt')
    grao = create(:grao, conteudo: conteudo)
    grao.referencia_abnt.should == 'referencia abnt'
  end
end
