class EventsRegistration < ActiveRecord::Base
  belongs_to :event
  belongs_to :registration
end
