class CreateTranslations < ActiveRecord::Migration[5.2]
  def change
    create_table :translations do |t|
      t.text :result
      t.references :document, foreign_key: true

      t.timestamps
    end
  end
end
