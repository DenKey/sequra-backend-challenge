# frozen_string_literal: true

class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants do |t|
      t.string :reference, index: { unique: true }, null: false
      t.string :email, null: false
      t.date   :live_on
      t.integer :disbursement_frequency, null: false
      t.decimal :minimum_monthly_fee, precision: 10, scale: 2

      t.timestamps
    end
  end
end
