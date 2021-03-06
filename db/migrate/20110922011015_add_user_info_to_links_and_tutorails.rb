class AddUserInfoToLinksAndTutorails < ActiveRecord::Migration
  def self.up
    add_column :links, :created_by_id, :integer
    add_column :links, :last_updated_by_id, :integer
    add_column :tutorials, :created_by_id, :integer
    add_column :tutorials, :last_updated_by_id, :integer
  end

  def self.down
    remove_column :links, :last_updated_by_id
    remove_column :links, :created_by_id
    remove_column :tutorials, :last_updated_by_id
    remove_column :tutorials, :created_by_id
  end
end
