class CreateTags < Sequel::Migration

  def up
    create_table :tags do
      primary_key :id, :type => :bigserial
      bigint :version, :null => false
      text :name, :unique => true
    end

    create_table :categories do
      primary_key :id, :type => :bigserial
      bigint :version, :null => false
      text :name, :unique => true
    end

    create_table :posts_categories do
      foreign_key :post_id, :posts, :type => :bigint, :null => false
      foreign_key :category_id, :categories, :type => :bigint, :null => false
    end

    create_table :posts_tags do
      foreign_key :post_id, :posts, :type => :bigint, :null => false
      foreign_key :tag_id, :tags, :type => :bigint, :null => false
    end
  end

  def down
    drop_table :posts_tags
    drop_table :posts_categories
    drop_table :categories
    drop_table :tags
  end

end
