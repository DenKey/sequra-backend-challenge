class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.boolean :disbursed, default: false
      t.decimal :amount, precision: 10, scale: 2
      t.string :reference, index: true, null: false
      t.belongs_to :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
