class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :property
      t.text :body
      t.text :title
      t.float :rating

      t.timestamps null: false
    end
  end
end
