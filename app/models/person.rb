class Person < ActiveRecord::Base
  attr_accessible :public_name
  belongs_to :user
  has_many :registrations
end