class AddTargetToTranslations < ActiveRecord::Migration[5.2]
  def change
    add_column :translations, :target, :string
  end
end
