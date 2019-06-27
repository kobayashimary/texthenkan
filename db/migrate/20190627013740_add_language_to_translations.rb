class AddLanguageToTranslations < ActiveRecord::Migration[5.2]
  def change
    add_column :translations, :language, :string
  end
end
