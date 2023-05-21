class ChangeStatusField < ActiveRecord::Migration[7.0]
  def change
    remove_column :servers, :status, :string
    add_column :servers, :status, :integer, default: Server.statuses[:creating]
  end
end
