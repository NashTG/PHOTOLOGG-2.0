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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 1) do

  create_table "amistads", primary_key: "ID_AMISTAD", force: :cascade do |t|
    t.integer  "ID_USUARIO",    limit: 4
    t.integer  "ID_AMIGO",      limit: 4
    t.datetime "FECHA_AMISTAD"
  end

  add_index "amistads", ["ID_USUARIO"], name: "FK_ESAMIGO", using: :btree

  create_table "auditorias", primary_key: "ID_AUDITORIA", force: :cascade do |t|
    t.integer  "ID_USUARIO", limit: 4
    t.string   "ACCION",     limit: 200
    t.string   "OLD",        limit: 200
    t.string   "NEW",        limit: 200
    t.datetime "TS",                     null: false
  end

  create_table "comentarios", primary_key: "ID_COMENTARIO", force: :cascade do |t|
    t.integer  "ID_FOTO",          limit: 4
    t.string   "COMENTARIO",       limit: 200
    t.integer  "PUNTAJE_ASIGNADO", limit: 4
    t.datetime "FECHA_COMENTARIO",             null: false
    t.integer  "ID_USUARIO",       limit: 4,   null: false
  end

  add_index "comentarios", ["ID_FOTO"], name: "FK_POSEE", using: :btree

  create_table "fotos", primary_key: "ID_FOTO", force: :cascade do |t|
    t.integer  "ID_USUARIO",           limit: 4
    t.string   "TITULO",               limit: 50
    t.binary   "FOTO",                 limit: 4294967295
    t.string   "DESCRIPCION",          limit: 200
    t.integer  "SUMA_PUNTAJE",         limit: 4,          default: 0
    t.float    "PUNTAJE_TOTAL",        limit: 24,         default: 0.0
    t.integer  "CANTIDAD_COMENTARIOS", limit: 4,          default: 0
    t.datetime "FECHA_SUBIDA",                                          null: false
  end

  add_index "fotos", ["ID_USUARIO"], name: "FK_SUBE", using: :btree

  create_table "usuarios", primary_key: "ID_USUARIO", force: :cascade do |t|
    t.string   "NICK",                   limit: 50,                 null: false
    t.string   "CONTRASENA",             limit: 50,                 null: false
    t.string   "NOMBRE",                 limit: 50,                 null: false
    t.string   "APELLIDO",               limit: 50
    t.string   "CORREO",                 limit: 50
    t.datetime "FECHA_INGRESO"
    t.boolean  "HABILITADO",                        default: true,  null: false
    t.boolean  "ES_ADMIN",                          default: false, null: false
    t.datetime "FECHA_UL_ACTUALIZACION",                            null: false
  end

  add_foreign_key "amistads", "usuarios", column: "ID_USUARIO", primary_key: "ID_USUARIO", name: "FK_ESAMIGO"
  add_foreign_key "comentarios", "fotos", column: "ID_FOTO", primary_key: "ID_FOTO", name: "FK_POSEE"
  add_foreign_key "fotos", "usuarios", column: "ID_USUARIO", primary_key: "ID_USUARIO", name: "FK_SUBE"
end
