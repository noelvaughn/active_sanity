class InvalidRecord < ActiveRecord::Base
  belongs_to :record, :polymorphic => true
  serialize :validation_errors

  validates_presence_of :record, :validation_errors
end
