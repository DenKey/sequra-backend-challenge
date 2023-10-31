class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.integer :type, null: false
      t.string :reference, index: { unique: true }
      t.belongs_to :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
