class CreateScheduledEvents < ActiveRecord::Migration
  def change
    create_table :scheduled_events do |t|
      t.string :event
      t.string :name
      t.string :at
      t.integer :frequency
      t.string :tz

      t.timestamps null: false
    end
  end
end
