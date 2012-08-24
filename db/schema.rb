# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120815235156) do

  create_table "acessos", :force => true do |t|
    t.date     "data"
    t.integer  "quantidade"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "areas", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "arquivos", :force => true do |t|
    t.string   "nome"
    t.string   "key"
    t.string   "mime_type"
    t.integer  "conteudo_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "thumbnail_key"
  end

  create_table "autores", :force => true do |t|
    t.string   "nome"
    t.string   "lattes"
    t.integer  "conteudo_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "buscas", :force => true do |t|
    t.string   "busca"
    t.string   "titulo"
    t.text     "descricao"
    t.integer  "usuario_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "mala_direta", :default => false
  end

  create_table "campi", :force => true do |t|
    t.string   "nome"
    t.integer  "instituicao_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "conteudos", :force => true do |t|
    t.string   "titulo"
    t.string   "link"
    t.text     "direitos"
    t.text     "resumo"
    t.string   "type"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "subtitulo"
    t.string   "nome_evento"
    t.string   "local_evento"
    t.integer  "numero_evento"
    t.integer  "ano_evento"
    t.string   "editora"
    t.integer  "ano_publicacao"
    t.string   "local_publicacao"
    t.string   "titulo_anais"
    t.integer  "pagina_inicial"
    t.integer  "pagina_final"
    t.string   "nome_periodico"
    t.string   "fasciculo"
    t.integer  "volume_publicacao"
    t.integer  "ano_primeiro_volume"
    t.integer  "ano_ultimo_volume"
    t.boolean  "traducao",            :default => false
    t.integer  "numero_edicao"
    t.integer  "numero_paginas"
    t.string   "palavras_chave"
    t.string   "tempo_aprendizagem"
    t.text     "novas_tags"
    t.integer  "idioma_id"
    t.date     "data_publicacao"
    t.date     "data_defesa"
    t.string   "instituicao"
    t.string   "local_defesa"
    t.integer  "grau_id"
    t.integer  "sub_area_id"
    t.string   "state"
    t.integer  "contribuidor_id"
    t.integer  "numero_de_acessos",   :default => 0
    t.integer  "campus_id"
    t.string   "tipo_trabalho"
    t.boolean  "pronatec"
  end

  create_table "cursos", :force => true do |t|
    t.string   "nome"
    t.integer  "eixo_tematico_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "cursos_objetos_de_aprendizagem", :id => false, :force => true do |t|
    t.integer "curso_id"
    t.integer "objeto_de_aprendizagem_id"
  end

  create_table "eixos_tematicos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "favoritos", :id => false, :force => true do |t|
    t.integer "usuario_id"
    t.integer "referencia_id"
  end

  create_table "graos", :force => true do |t|
    t.integer  "conteudo_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "tipo"
    t.string   "key"
  end

  create_table "graus", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "idiomas", :force => true do |t|
    t.string   "sigla"
    t.string   "descricao"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "instituicoes", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mudancas_de_estado", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "conteudo_id"
    t.string   "de"
    t.string   "para"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "motivo"
  end

  add_index "mudancas_de_estado", ["conteudo_id"], :name => "index_mudancas_de_estado_on_conteudo_id"
  add_index "mudancas_de_estado", ["usuario_id"], :name => "index_mudancas_de_estado_on_usuario_id"

  create_table "papeis", :force => true do |t|
    t.string "nome"
    t.string "descricao"
  end

  create_table "papeis_usuarios", :id => false, :force => true do |t|
    t.integer "usuario_id"
    t.integer "papel_id"
  end

  create_table "referencias", :force => true do |t|
    t.string   "abnt"
    t.string   "tipo_do_grao"
    t.integer  "referenciavel_id"
    t.string   "referenciavel_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "referencias_nas_cestas", :id => false, :force => true do |t|
    t.integer "usuario_id"
    t.integer "referencia_id"
  end

  create_table "sub_areas", :force => true do |t|
    t.string   "nome"
    t.integer  "area_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "usuarios", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "nome_completo"
    t.integer  "campus_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "usuarios", ["email"], :name => "index_usuarios_on_email", :unique => true
  add_index "usuarios", ["reset_password_token"], :name => "index_usuarios_on_reset_password_token", :unique => true

end
