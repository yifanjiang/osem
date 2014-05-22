class Vote < ActiveRecord::Base
  attr_accessible :rating
  
  belongs_to :conference_person
  belongs_to :event
  
  delegate :first_name, :to => :conference_person
  delegate :last_name, :to => :conference_person
  delegate :public_name, :to => :conference_person
end