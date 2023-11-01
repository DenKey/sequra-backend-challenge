class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.integer :fee_type, null: false
      t.date :operated_at
      t.string :reference, index: { unique: true }
      t.belongs_to :merchant, null: false, foreign_key: true

      t.timestamps
    end
    add_index :disbursements, [:operated_at, :merchant_id, :fee_type], unique: true
  end
end
