ActiveRecord::Schema.define(:version => 20090226212642) do
  create_table "primaries", :force => true do |t|
    t.string "name"
  end

  create_table "secondaries", :force => true do |t|
    t.string  "name"
    t.integer "primary_id"
  end

  add_index "secondaries", ["primary_id"], :name => "index_roles_on_name"
end
