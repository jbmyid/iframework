class CreateDemoIframeworks < ActiveRecord::Migration
  def change
    create_table :demo_iframeworks do |t|
      t.string :email
      t.string :password

      t.timestamps null: false
    end
  end
end
