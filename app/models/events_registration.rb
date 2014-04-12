class EventsRegistration < ActiveRecord::Base
  has_paper_trail
  belongs_to :event
  belongs_to :registration
end
