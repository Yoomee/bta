class CreateBlockedIpAddresses < ActiveRecord::Migration
  def self.up
    create_table :blocked_ip_addresses do |t|
      t.string :ip_address
      t.datetime :created_at
    end
    add_index :blocked_ip_addresses, :ip_address, :unique => true
    Member.find(:all, :conditions => {:banned_from_forum => true}).each do |member|
      member.block_all_ip_addresses!
    end
  end

  def self.down
    drop_table :blocked_ip_addresses
  end
end
