class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :public_id

      t.bigint :assignee_id
      t.bigint :creator_id

      t.string :status
      t.text :description

      t.timestamps

    end
  end
end
