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

ActiveRecord::Schema.define(version: 20171205163159) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"
  enable_extension "fuzzystrmatch"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "uuid-ossp"

  create_table "addr", primary_key: "gid", force: :cascade do |t|
    t.bigint  "tlid"
    t.string  "fromhn",    limit: 12
    t.string  "tohn",      limit: 12
    t.string  "side",      limit: 1
    t.string  "zip",       limit: 5
    t.string  "plus4",     limit: 4
    t.string  "fromtyp",   limit: 1
    t.string  "totyp",     limit: 1
    t.integer "fromarmid"
    t.integer "toarmid"
    t.string  "arid",      limit: 22
    t.string  "mtfcc",     limit: 5
    t.string  "statefp",   limit: 2
    t.index ["tlid", "statefp"], name: "idx_tiger_addr_tlid_statefp", using: :btree
    t.index ["zip"], name: "idx_tiger_addr_zip", using: :btree
  end

  create_table "addrfeat", primary_key: "gid", force: :cascade do |t|
    t.bigint   "tlid"
    t.string   "statefp",    limit: 2,                                   null: false
    t.string   "aridl",      limit: 22
    t.string   "aridr",      limit: 22
    t.string   "linearid",   limit: 22
    t.string   "fullname",   limit: 100
    t.string   "lfromhn",    limit: 12
    t.string   "ltohn",      limit: 12
    t.string   "rfromhn",    limit: 12
    t.string   "rtohn",      limit: 12
    t.string   "zipl",       limit: 5
    t.string   "zipr",       limit: 5
    t.string   "edge_mtfcc", limit: 5
    t.string   "parityl",    limit: 1
    t.string   "parityr",    limit: 1
    t.string   "plus4l",     limit: 4
    t.string   "plus4r",     limit: 4
    t.string   "lfromtyp",   limit: 1
    t.string   "ltotyp",     limit: 1
    t.string   "rfromtyp",   limit: 1
    t.string   "rtotyp",     limit: 1
    t.string   "offsetl",    limit: 1
    t.string   "offsetr",    limit: 1
    t.geometry "the_geom",   limit: {:srid=>4269, :type=>"line_string"}
    t.index ["the_geom"], name: "idx_addrfeat_geom_gist", using: :gist
    t.index ["tlid"], name: "idx_addrfeat_tlid", using: :btree
    t.index ["zipl"], name: "idx_addrfeat_zipl", using: :btree
    t.index ["zipr"], name: "idx_addrfeat_zipr", using: :btree
  end

  create_table "affiliations", force: :cascade do |t|
    t.uuid     "user_id",                         null: false
    t.uuid     "organization_id",                 null: false
    t.boolean  "primary",         default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["organization_id"], name: "index_affiliations_on_organization_id", using: :btree
    t.index ["primary"], name: "index_affiliations_on_primary", using: :btree
    t.index ["user_id"], name: "index_affiliations_on_user_id", using: :btree
  end

  create_table "bg", primary_key: "bg_id", id: :string, limit: 12, force: :cascade, comment: "block groups" do |t|
    t.serial   "gid",                                                    null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "tractce",  limit: 6
    t.string   "blkgrpce", limit: 1
    t.string   "namelsad", limit: 13
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.float    "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  create_table "collection_tags", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name",        null: false
    t.string "description", null: false
    t.index ["name"], name: "index_collection_tags_on_name", using: :btree
  end

  create_table "contexts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_contexts_on_name", using: :btree
  end

  create_table "county", primary_key: "cntyidfp", id: :string, limit: 5, force: :cascade do |t|
    t.serial   "gid",                                                    null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "countyns", limit: 8
    t.string   "name",     limit: 100
    t.string   "namelsad", limit: 100
    t.string   "lsad",     limit: 2
    t.string   "classfp",  limit: 2
    t.string   "mtfcc",    limit: 5
    t.string   "csafp",    limit: 3
    t.string   "cbsafp",   limit: 5
    t.string   "metdivfp", limit: 5
    t.string   "funcstat", limit: 1
    t.bigint   "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
    t.index ["countyfp"], name: "idx_tiger_county", using: :btree
    t.index ["gid"], name: "uidx_county_gid", unique: true, using: :btree
  end

  create_table "county_lookup", primary_key: ["st_code", "co_code"], force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "co_code",            null: false
    t.string  "name",    limit: 90
    t.index "soundex((name)::text)", name: "county_lookup_name_idx", using: :btree
    t.index ["state"], name: "county_lookup_state_idx", using: :btree
  end

  create_table "countysub_lookup", primary_key: ["st_code", "co_code", "cs_code"], force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "co_code",            null: false
    t.string  "county",  limit: 90
    t.integer "cs_code",            null: false
    t.string  "name",    limit: 90
    t.index "soundex((name)::text)", name: "countysub_lookup_name_idx", using: :btree
    t.index ["state"], name: "countysub_lookup_state_idx", using: :btree
  end

  create_table "cousub", primary_key: "cosbidfp", id: :string, limit: 10, force: :cascade do |t|
    t.serial   "gid",                                                                   null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "cousubfp", limit: 5
    t.string   "cousubns", limit: 8
    t.string   "name",     limit: 100
    t.string   "namelsad", limit: 100
    t.string   "lsad",     limit: 2
    t.string   "classfp",  limit: 2
    t.string   "mtfcc",    limit: 5
    t.string   "cnectafp", limit: 3
    t.string   "nectafp",  limit: 5
    t.string   "nctadvfp", limit: 5
    t.string   "funcstat", limit: 1
    t.decimal  "aland",                                                  precision: 14
    t.decimal  "awater",                                                 precision: 14
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
    t.index ["gid"], name: "uidx_cousub_gid", unique: true, using: :btree
    t.index ["the_geom"], name: "tige_cousub_the_geom_gist", using: :gist
  end

  create_table "direction_lookup", primary_key: "name", id: :string, limit: 20, force: :cascade do |t|
    t.string "abbrev", limit: 3
    t.index ["abbrev"], name: "direction_lookup_abbrev_idx", using: :btree
  end

  create_table "edges", primary_key: "gid", force: :cascade do |t|
    t.string   "statefp",    limit: 2
    t.string   "countyfp",   limit: 3
    t.bigint   "tlid"
    t.decimal  "tfidl",                                                        precision: 10
    t.decimal  "tfidr",                                                        precision: 10
    t.string   "mtfcc",      limit: 5
    t.string   "fullname",   limit: 100
    t.string   "smid",       limit: 22
    t.string   "lfromadd",   limit: 12
    t.string   "ltoadd",     limit: 12
    t.string   "rfromadd",   limit: 12
    t.string   "rtoadd",     limit: 12
    t.string   "zipl",       limit: 5
    t.string   "zipr",       limit: 5
    t.string   "featcat",    limit: 1
    t.string   "hydroflg",   limit: 1
    t.string   "railflg",    limit: 1
    t.string   "roadflg",    limit: 1
    t.string   "olfflg",     limit: 1
    t.string   "passflg",    limit: 1
    t.string   "divroad",    limit: 1
    t.string   "exttyp",     limit: 1
    t.string   "ttyp",       limit: 1
    t.string   "deckedroad", limit: 1
    t.string   "artpath",    limit: 1
    t.string   "persist",    limit: 1
    t.string   "gcseflg",    limit: 1
    t.string   "offsetl",    limit: 1
    t.string   "offsetr",    limit: 1
    t.decimal  "tnidf",                                                        precision: 10
    t.decimal  "tnidt",                                                        precision: 10
    t.geometry "the_geom",   limit: {:srid=>4269, :type=>"multi_line_string"}
    t.index ["countyfp"], name: "idx_tiger_edges_countyfp", using: :btree
    t.index ["the_geom"], name: "idx_tiger_edges_the_geom_gist", using: :gist
    t.index ["tlid"], name: "idx_edges_tlid", using: :btree
  end

  create_table "faces", primary_key: "gid", force: :cascade do |t|
    t.decimal  "tfid",                                                     precision: 10
    t.string   "statefp00",  limit: 2
    t.string   "countyfp00", limit: 3
    t.string   "tractce00",  limit: 6
    t.string   "blkgrpce00", limit: 1
    t.string   "blockce00",  limit: 4
    t.string   "cousubfp00", limit: 5
    t.string   "submcdfp00", limit: 5
    t.string   "conctyfp00", limit: 5
    t.string   "placefp00",  limit: 5
    t.string   "aiannhfp00", limit: 5
    t.string   "aiannhce00", limit: 4
    t.string   "comptyp00",  limit: 1
    t.string   "trsubfp00",  limit: 5
    t.string   "trsubce00",  limit: 3
    t.string   "anrcfp00",   limit: 5
    t.string   "elsdlea00",  limit: 5
    t.string   "scsdlea00",  limit: 5
    t.string   "unsdlea00",  limit: 5
    t.string   "uace00",     limit: 5
    t.string   "cd108fp",    limit: 2
    t.string   "sldust00",   limit: 3
    t.string   "sldlst00",   limit: 3
    t.string   "vtdst00",    limit: 6
    t.string   "zcta5ce00",  limit: 5
    t.string   "tazce00",    limit: 6
    t.string   "ugace00",    limit: 5
    t.string   "puma5ce00",  limit: 5
    t.string   "statefp",    limit: 2
    t.string   "countyfp",   limit: 3
    t.string   "tractce",    limit: 6
    t.string   "blkgrpce",   limit: 1
    t.string   "blockce",    limit: 4
    t.string   "cousubfp",   limit: 5
    t.string   "submcdfp",   limit: 5
    t.string   "conctyfp",   limit: 5
    t.string   "placefp",    limit: 5
    t.string   "aiannhfp",   limit: 5
    t.string   "aiannhce",   limit: 4
    t.string   "comptyp",    limit: 1
    t.string   "trsubfp",    limit: 5
    t.string   "trsubce",    limit: 3
    t.string   "anrcfp",     limit: 5
    t.string   "ttractce",   limit: 6
    t.string   "tblkgpce",   limit: 1
    t.string   "elsdlea",    limit: 5
    t.string   "scsdlea",    limit: 5
    t.string   "unsdlea",    limit: 5
    t.string   "uace",       limit: 5
    t.string   "cd111fp",    limit: 2
    t.string   "sldust",     limit: 3
    t.string   "sldlst",     limit: 3
    t.string   "vtdst",      limit: 6
    t.string   "zcta5ce",    limit: 5
    t.string   "tazce",      limit: 6
    t.string   "ugace",      limit: 5
    t.string   "puma5ce",    limit: 5
    t.string   "csafp",      limit: 3
    t.string   "cbsafp",     limit: 5
    t.string   "metdivfp",   limit: 5
    t.string   "cnectafp",   limit: 3
    t.string   "nectafp",    limit: 5
    t.string   "nctadvfp",   limit: 5
    t.string   "lwflag",     limit: 1
    t.string   "offset",     limit: 1
    t.float    "atotal"
    t.string   "intptlat",   limit: 11
    t.string   "intptlon",   limit: 12
    t.geometry "the_geom",   limit: {:srid=>4269, :type=>"multi_polygon"}
    t.index ["countyfp"], name: "idx_tiger_faces_countyfp", using: :btree
    t.index ["tfid"], name: "idx_tiger_faces_tfid", using: :btree
    t.index ["the_geom"], name: "tiger_faces_the_geom_gist", using: :gist
  end

  create_table "featnames", primary_key: "gid", force: :cascade do |t|
    t.bigint "tlid"
    t.string "fullname",   limit: 100
    t.string "name",       limit: 100
    t.string "predirabrv", limit: 15
    t.string "pretypabrv", limit: 50
    t.string "prequalabr", limit: 15
    t.string "sufdirabrv", limit: 15
    t.string "suftypabrv", limit: 50
    t.string "sufqualabr", limit: 15
    t.string "predir",     limit: 2
    t.string "pretyp",     limit: 3
    t.string "prequal",    limit: 2
    t.string "sufdir",     limit: 2
    t.string "suftyp",     limit: 3
    t.string "sufqual",    limit: 2
    t.string "linearid",   limit: 22
    t.string "mtfcc",      limit: 5
    t.string "paflag",     limit: 1
    t.string "statefp",    limit: 2
    t.index "lower((name)::text)", name: "idx_tiger_featnames_lname", using: :btree
    t.index "soundex((name)::text)", name: "idx_tiger_featnames_snd_name", using: :btree
    t.index ["tlid", "statefp"], name: "idx_tiger_featnames_tlid_statefp", using: :btree
  end

  create_table "generic_tags", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_generic_tags_on_name", using: :btree
  end

  create_table "geocode_settings", primary_key: "name", id: :text, force: :cascade do |t|
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

  create_table "geocode_settings_default", primary_key: "name", id: :text, force: :cascade do |t|
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

  create_table "invited_users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "email",        null: false
    t.json     "data"
    t.string   "name"
    t.string   "invite_link",  null: false
    t.datetime "confirmed_at"
    t.datetime "created_at",   null: false
    t.index ["email"], name: "index_invited_users_on_email", using: :btree
    t.index ["invite_link"], name: "index_invited_users_on_invite_link", using: :btree
    t.index ["name"], name: "index_invited_users_on_name", using: :btree
  end

  create_table "involvements", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_involvements_on_name", using: :btree
  end

  create_table "lesson_tags", force: :cascade do |t|
    t.uuid     "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.uuid     "lesson_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["lesson_id"], name: "index_lesson_tags_on_lesson_id", using: :btree
    t.index ["taggable_type", "taggable_id"], name: "index_lesson_tags_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "lessons", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",                      default: "", null: false
    t.string   "topline",                   default: "", null: false
    t.string   "summary",                   default: "", null: false
    t.string   "learning_objectives",                                 array: true
    t.string   "teacher_notes",             default: "", null: false
    t.string   "assessment_criteria",       default: "", null: false
    t.string   "assessment_criteria_files", default: [],              array: true
    t.string   "further_readings",                                    array: true
    t.json     "standards"
    t.string   "outcome_files",             default: [],              array: true
    t.uuid     "original_lesson"
    t.integer  "state",                     default: 1,  null: false
    t.datetime "published_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "key_concepts",              default: [],              array: true
    t.string   "key_vocabularies",          default: [],              array: true
    t.string   "key_formulas",              default: [],              array: true
    t.string   "fabrication_tools",         default: [],              array: true
    t.index ["name"], name: "index_lessons_on_name", using: :btree
    t.index ["original_lesson"], name: "index_lessons_on_original_lesson", using: :btree
    t.index ["state"], name: "index_lessons_on_state", using: :btree
  end

  create_table "lessons_standards", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid    "lesson_id",   null: false
    t.uuid    "standard_id", null: false
    t.string  "description"
    t.integer "index"
    t.index ["lesson_id"], name: "index_lessons_standards_on_lesson_id", using: :btree
    t.index ["standard_id"], name: "index_lessons_standards_on_standard_id", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.uuid     "lesson_id",  null: false
    t.uuid     "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_likes_on_lesson_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "loader_lookuptables", primary_key: "lookup_name", id: :text, force: :cascade do |t|
    t.integer "process_order",                   default: 1000,  null: false
    t.text    "table_name"
    t.boolean "single_mode",                     default: true,  null: false
    t.boolean "load",                            default: true,  null: false
    t.boolean "level_county",                    default: false, null: false
    t.boolean "level_state",                     default: false, null: false
    t.boolean "level_nation",                    default: false, null: false
    t.text    "post_load_process"
    t.boolean "single_geom_mode",                default: false
    t.string  "insert_mode",           limit: 1, default: "c",   null: false
    t.text    "pre_load_process"
    t.text    "columns_exclude",                                              array: true
    t.text    "website_root_override"
  end

  create_table "loader_platform", primary_key: "os", id: :string, limit: 50, force: :cascade do |t|
    t.text "declare_sect"
    t.text "pgbin"
    t.text "wget"
    t.text "unzip_command"
    t.text "psql"
    t.text "path_sep"
    t.text "loader"
    t.text "environ_set_command"
    t.text "county_process_command"
  end

  create_table "loader_variables", primary_key: "tiger_year", id: :string, limit: 4, force: :cascade do |t|
    t.text "website_root"
    t.text "staging_fold"
    t.text "data_schema"
    t.text "staging_schema"
  end

  create_table "mastery_levels", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "level",  default: 0, null: false
    t.integer "metric", default: 0, null: false
    t.index ["level"], name: "index_mastery_levels_on_level", using: :btree
    t.index ["metric"], name: "index_mastery_levels_on_metric", using: :btree
  end

  create_table "org_tags", force: :cascade do |t|
    t.uuid     "taggable_id",     null: false
    t.string   "taggable_type",   null: false
    t.uuid     "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_org_tags_on_organization_id", using: :btree
    t.index ["taggable_type", "taggable_id"], name: "index_org_tags_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "organizations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string    "name",                                                                      default: "", null: false
    t.string    "desc",                                                                      default: "", null: false
    t.json      "social"
    t.string    "contact_email"
    t.integer   "state",                                                                     default: 0,  null: false
    t.string    "address_line1"
    t.string    "address_line2"
    t.string    "address_line3"
    t.string    "address_line4"
    t.string    "locality"
    t.string    "region"
    t.string    "post_code"
    t.string    "country"
    t.geography "lonlat",        limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.datetime  "created_at",                                                                             null: false
    t.datetime  "updated_at",                                                                             null: false
    t.index ["contact_email"], name: "index_organizations_on_contact_email", using: :btree
    t.index ["lonlat"], name: "index_organizations_on_lonlat", using: :btree
    t.index ["name"], name: "index_organizations_on_name", using: :btree
    t.index ["post_code"], name: "index_organizations_on_post_code", using: :btree
    t.index ["state"], name: "index_organizations_on_state", using: :btree
  end

  create_table "other_interests", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_other_interests_on_name", using: :btree
  end

  create_table "pagc_gaz", force: :cascade do |t|
    t.integer "seq"
    t.text    "word"
    t.text    "stdword"
    t.integer "token"
    t.boolean "is_custom", default: true, null: false
  end

  create_table "pagc_lex", force: :cascade do |t|
    t.integer "seq"
    t.text    "word"
    t.text    "stdword"
    t.integer "token"
    t.boolean "is_custom", default: true, null: false
  end

  create_table "pagc_rules", force: :cascade do |t|
    t.text    "rule"
    t.boolean "is_custom", default: true
  end

  create_table "place", primary_key: "plcidfp", id: :string, limit: 7, force: :cascade do |t|
    t.serial   "gid",                                                    null: false
    t.string   "statefp",  limit: 2
    t.string   "placefp",  limit: 5
    t.string   "placens",  limit: 8
    t.string   "name",     limit: 100
    t.string   "namelsad", limit: 100
    t.string   "lsad",     limit: 2
    t.string   "classfp",  limit: 2
    t.string   "cpi",      limit: 1
    t.string   "pcicbsa",  limit: 1
    t.string   "pcinecta", limit: 1
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.bigint   "aland"
    t.bigint   "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
    t.index ["gid"], name: "uidx_tiger_place_gid", unique: true, using: :btree
    t.index ["the_geom"], name: "tiger_place_the_geom_gist", using: :gist
  end

  create_table "place_lookup", primary_key: ["st_code", "pl_code"], force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "pl_code",            null: false
    t.string  "name",    limit: 90
    t.index "soundex((name)::text)", name: "place_lookup_name_idx", using: :btree
    t.index ["state"], name: "place_lookup_state_idx", using: :btree
  end

  create_table "secondary_unit_lookup", primary_key: "name", id: :string, limit: 20, force: :cascade do |t|
    t.string "abbrev", limit: 5
    t.index ["abbrev"], name: "secondary_unit_lookup_abbrev_idx", using: :btree
  end

  create_table "skill_tags", force: :cascade do |t|
    t.uuid    "taggable_id",               null: false
    t.string  "taggable_type",             null: false
    t.integer "skill_id",                  null: false
    t.integer "level",         default: 0, null: false
    t.index ["level"], name: "index_skill_tags_on_level", using: :btree
    t.index ["skill_id"], name: "index_skill_tags_on_skill_id", using: :btree
    t.index ["taggable_type", "taggable_id"], name: "index_skill_tags_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_skills_on_name", using: :btree
  end

  create_table "standards", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name",         null: false
    t.string "autocomplete"
    t.index ["name"], name: "index_standards_on_name", using: :btree
  end

  create_table "state", primary_key: "statefp", id: :string, limit: 2, force: :cascade do |t|
    t.serial   "gid",                                                    null: false
    t.string   "region",   limit: 2
    t.string   "division", limit: 2
    t.string   "statens",  limit: 8
    t.string   "stusps",   limit: 2,                                     null: false
    t.string   "name",     limit: 100
    t.string   "lsad",     limit: 2
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.bigint   "aland"
    t.bigint   "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
    t.index ["gid"], name: "uidx_tiger_state_gid", unique: true, using: :btree
    t.index ["stusps"], name: "uidx_tiger_state_stusps", unique: true, using: :btree
    t.index ["the_geom"], name: "idx_tiger_state_the_geom_gist", using: :gist
  end

  create_table "state_lookup", primary_key: "st_code", id: :integer, force: :cascade do |t|
    t.string "name",    limit: 40
    t.string "abbrev",  limit: 3
    t.string "statefp", limit: 2
    t.index ["abbrev"], name: "state_lookup_abbrev_key", unique: true, using: :btree
    t.index ["name"], name: "state_lookup_name_key", unique: true, using: :btree
    t.index ["statefp"], name: "state_lookup_statefp_key", unique: true, using: :btree
  end

  create_table "steps", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "lesson_id",                          null: false
    t.string   "summary",                            null: false
    t.integer  "duration",              default: 0,  null: false
    t.string   "description",           default: "", null: false
    t.string   "images",                default: [],              array: true
    t.json     "materials"
    t.string   "tools",                                           array: true
    t.string   "design_files",          default: [],              array: true
    t.string   "external_links",                                  array: true
    t.integer  "step_number",                        null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "software",              default: [],              array: true
    t.string   "fabrication_equipment", default: [],              array: true
    t.string   "name"
    t.index ["lesson_id"], name: "index_steps_on_lesson_id", using: :btree
  end

  create_table "street_type_lookup", primary_key: "name", id: :string, limit: 50, force: :cascade do |t|
    t.string  "abbrev", limit: 50
    t.boolean "is_hw",             default: false, null: false
    t.index ["abbrev"], name: "street_type_lookup_abbrev_idx", using: :btree
  end

  create_table "subjects", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_subjects_on_name", using: :btree
  end

  create_table "tabblock", primary_key: "tabblock_id", id: :string, limit: 16, force: :cascade do |t|
    t.serial   "gid",                                                    null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "tractce",  limit: 6
    t.string   "blockce",  limit: 4
    t.string   "name",     limit: 20
    t.string   "mtfcc",    limit: 5
    t.string   "ur",       limit: 1
    t.string   "uace",     limit: 5
    t.string   "funcstat", limit: 1
    t.float    "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  create_table "teaching_ranges", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "range_start", default: 0, null: false
    t.integer "range_end",   default: 0, null: false
  end

  create_table "tract", primary_key: "tract_id", id: :string, limit: 11, force: :cascade do |t|
    t.serial   "gid",                                                    null: false
    t.string   "statefp",  limit: 2
    t.string   "countyfp", limit: 3
    t.string   "tractce",  limit: 6
    t.string   "name",     limit: 7
    t.string   "namelsad", limit: 20
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.float    "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
  end

  create_table "user_tags", force: :cascade do |t|
    t.uuid     "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.uuid     "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["taggable_type", "taggable_id"], name: "index_user_tags_on_taggable_type_and_taggable_id", using: :btree
    t.index ["user_id"], name: "index_user_tags_on_user_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string    "email",                                                                              default: "", null: false
    t.string    "encrypted_password",                                                                 default: "", null: false
    t.string    "reset_password_token"
    t.datetime  "reset_password_sent_at"
    t.datetime  "remember_created_at"
    t.integer   "sign_in_count",                                                                      default: 0,  null: false
    t.datetime  "current_sign_in_at"
    t.datetime  "last_sign_in_at"
    t.inet      "current_sign_in_ip"
    t.inet      "last_sign_in_ip"
    t.integer   "role",                                                                               default: 0,  null: false
    t.string    "name",                                                                               default: "", null: false
    t.string    "avatar",                                                                             default: ""
    t.string    "address_line1"
    t.string    "address_line2"
    t.string    "address_line3"
    t.string    "address_line4"
    t.string    "locality"
    t.string    "region"
    t.string    "post_code"
    t.string    "country"
    t.geography "lonlat",                 limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string    "bio",                                                                                default: "", null: false
    t.json      "social"
    t.json      "settings",                                                                                        null: false
    t.datetime  "created_at",                                                                                      null: false
    t.datetime  "updated_at",                                                                                      null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["lonlat"], name: "index_users_on_lonlat", using: :btree
    t.index ["post_code"], name: "index_users_on_post_code", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  end

  create_table "zcta5", primary_key: ["zcta5ce", "statefp"], force: :cascade do |t|
    t.serial   "gid",                                                    null: false
    t.string   "statefp",  limit: 2,                                     null: false
    t.string   "zcta5ce",  limit: 5,                                     null: false
    t.string   "classfp",  limit: 2
    t.string   "mtfcc",    limit: 5
    t.string   "funcstat", limit: 1
    t.float    "aland"
    t.float    "awater"
    t.string   "intptlat", limit: 11
    t.string   "intptlon", limit: 12
    t.string   "partflg",  limit: 1
    t.geometry "the_geom", limit: {:srid=>4269, :type=>"multi_polygon"}
    t.index ["gid"], name: "uidx_tiger_zcta5_gid", unique: true, using: :btree
  end

  create_table "zip_lookup", primary_key: "zip", id: :integer, force: :cascade do |t|
    t.integer "st_code"
    t.string  "state",   limit: 2
    t.integer "co_code"
    t.string  "county",  limit: 90
    t.integer "cs_code"
    t.string  "cousub",  limit: 90
    t.integer "pl_code"
    t.string  "place",   limit: 90
    t.integer "cnt"
  end

  create_table "zip_lookup_all", id: false, force: :cascade do |t|
    t.integer "zip"
    t.integer "st_code"
    t.string  "state",   limit: 2
    t.integer "co_code"
    t.string  "county",  limit: 90
    t.integer "cs_code"
    t.string  "cousub",  limit: 90
    t.integer "pl_code"
    t.string  "place",   limit: 90
    t.integer "cnt"
  end

  create_table "zip_lookup_base", primary_key: "zip", id: :string, limit: 5, force: :cascade do |t|
    t.string "state",   limit: 40
    t.string "county",  limit: 90
    t.string "city",    limit: 90
    t.string "statefp", limit: 2
  end

  create_table "zip_state", primary_key: ["zip", "stusps"], force: :cascade do |t|
    t.string "zip",     limit: 5, null: false
    t.string "stusps",  limit: 2, null: false
    t.string "statefp", limit: 2
  end

  create_table "zip_state_loc", primary_key: ["zip", "stusps", "place"], force: :cascade do |t|
    t.string "zip",     limit: 5,   null: false
    t.string "stusps",  limit: 2,   null: false
    t.string "statefp", limit: 2
    t.string "place",   limit: 100, null: false
  end

  add_foreign_key "affiliations", "organizations"
  add_foreign_key "affiliations", "users"
  add_foreign_key "lesson_tags", "lessons"
  add_foreign_key "lessons_standards", "lessons"
  add_foreign_key "lessons_standards", "standards"
  add_foreign_key "likes", "lessons"
  add_foreign_key "likes", "users"
  add_foreign_key "org_tags", "organizations"
  add_foreign_key "skill_tags", "skills"
  add_foreign_key "steps", "lessons"
  add_foreign_key "user_tags", "users"
end
