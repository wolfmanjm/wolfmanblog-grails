class CreateComment < Sequel::Migration

  def up
    create_table :comments do
      primary_key :id, :type => :bigserial
      bigint :version, :null => false
      text :name
      text :body, :null => false
      text :email
      text :url
      varchar :guid, :size => 255
      foreign_key :post_id, :posts, :type => :bigint, :null => false, :index => true
      timestamp :date_created, :null => false
      timestamp :last_updated, :null => false
    end
  end

  def down
    drop_table :comments
  end

end
