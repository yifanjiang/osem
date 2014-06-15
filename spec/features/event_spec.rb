require 'spec_helper'

feature Event do
  # It is necessary to use bang version of let to build roles before user
  let!(:admin_role) { create(:admin_role) }
  let!(:admin) { create(:admin) }
  let!(:conference) { create(:conference) }
  let!(:call_for_papers) { create(:call_for_papers, conference_id: conference.id, rating: 0, start_date: Date.today, end_date: Date.today) }
  let!(:event_type) { create(:event_type) }
  let!(:event) { create(:event, title: 'Test event', event_type_id: event_type.id, conference_id: conference.id) }

  shared_examples 'events in admin panel' do
    scenario 'new event is visible in admin panel from events index and show actions' do
      sign_in admin
      visit admin_conference_events_path(conference.short_title)
      expect(page.has_content?('Test event')).to be true

      visit admin_conference_event_path(conference.short_title, event)
      expect(page.has_content?('Test event')).to be true
    end
  end

  describe 'appears in admin panel' do
    it_behaves_like 'events in admin panel'
  end
end