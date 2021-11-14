class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :public_id
      t.string :role

      t.timestamps
    end
  end
end
