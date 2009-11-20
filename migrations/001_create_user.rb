class CreateUser < Sequel::Migration

  def up
    create_table :users do
      primary_key :id, :type => :bigserial
      varchar :name, :size => 20, :null => false
      varchar :crypted_password, :size => 64, :null => false
      varchar :salt, :size => 64, :null => false
      boolean :admin
      bigint :version, :null => false
      timestamp :date_created, :null => false
      index 'lower(name)'.lit, :unique => true, :name => 'name_idx'
    end
  end

  def down
    drop_table :users
  end

end
