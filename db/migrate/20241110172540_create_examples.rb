class CreateExamples < ActiveRecord::Migration[7.2]
  def change
    create_table :examples do |t|
      t.string :username
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
