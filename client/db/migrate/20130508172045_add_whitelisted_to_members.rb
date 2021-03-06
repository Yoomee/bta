class AddWhitelistedToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :whitelisted, :boolean, :default => false
    Member.reset_column_information
    Member.find(:all, :conditions => {:is_admin => true}).each  do |member|
      member.update_attributes(:whitelisted => true, :banned_from_forum => false)
    end
  end

  def self.down
    remove_column :members, :whitelisted
  end
end
