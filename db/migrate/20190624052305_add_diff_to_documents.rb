class AddDiffToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :diff, :text
  end
end
