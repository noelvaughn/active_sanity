class CreateInvalidRecords < ActiveRecord::Migration
  def self.up
    create_table :invalid_records do |t|
      t.references :record, :polymorphic => true, :null => false
      t.text :validation_errors
      t.timestamps
    end
    add_index :invalid_records, [:record_type, :record_id]
  end

  def self.down
    drop_table :invalid_records
  end
end

