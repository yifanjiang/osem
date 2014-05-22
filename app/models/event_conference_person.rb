class EventConferencePerson < ActiveRecord::Base
  attr_accessible :event, :conference_person, :conference_person_id, :event_role
  # TODO Do we need these roles?
  ROLES = [["Speaker","speaker"], ["Submitter","submitter"], ["Moderator","moderator"]]

  belongs_to :event
  belongs_to :conference_person
end