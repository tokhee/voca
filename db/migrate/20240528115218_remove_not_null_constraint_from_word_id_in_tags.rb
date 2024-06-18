class RemoveNotNullConstraintFromWordIdInTags < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tags, :word_id, true
  end
end
