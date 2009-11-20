class CreateStatics < Sequel::Migration

  def up
    create_table :statics do
      primary_key :id, :type => :bigserial
      bigint :version, :null => false
      text :title, :null => false
      text :body, :null => false
      integer :position, :default => 0
    end
  end

  def down
    drop_table :statics
  end

end
