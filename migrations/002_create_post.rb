class CreatePost < Sequel::Migration

  def up
    create_table :posts do
      primary_key :id, :type => :bigserial
      bigint :version, :null => false
      text :body, :null => false
      varchar :title, :size => 255, :null => false
      varchar :author, :size => 128
      varchar :permalink, :size => 255, :unique => true
      varchar :guid, :size => 64, :null => false
      boolean :allow_comments, :default => true
      boolean :comments_closed, :default => false
      timestamp :date_created, :null => false
      timestamp :last_updated, :null => false
    end
  end

  def down
    drop_table :posts
  end

end
