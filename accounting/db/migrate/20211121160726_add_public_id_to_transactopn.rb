class AddPublicIdToTransactopn < ActiveRecord::Migration[6.1]
  def change
     add_column :transactions, :public_id, :string
  end
end
