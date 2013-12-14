class Role < ActiveRecord::Base
  attr_accessible :name, :description
  belongs_to :conference
  has_and_belongs_to_many :users
end