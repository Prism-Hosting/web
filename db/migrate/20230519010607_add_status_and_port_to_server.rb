class AddStatusAndPortToServer < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :status, :string, default: "Unknown"
    add_column :servers, :port, :integer
  end
end
