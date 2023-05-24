class AddLogsToServer < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :logs, :string
  end
end
