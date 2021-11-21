class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :public_id
      t.string :title
      t.bigint :account_id
      t.bigint :task_id
      t.integer :amount
      t.string :status

      t.timestamps
    end
  end
end
