class ConferenceRegistrationController < ApplicationController
  before_filter :verify_user

  def register
    # TODO Figure out how to change the route's id from :id to :conference_id
    @conference = Conference.find_by(short_title: params[:id])
    @workshops = @conference.events.where("require_registration = ? AND state LIKE ?", true, 'confirmed')
    @person = current_user.conference_person
    if @person.first_name.blank? || @person.last_name.blank?
      redirect_to(edit_user_registration_path, :alert => "Please fill in your first and last name before registering.")
      return
    end
    @registration = @person.registrations.where(:conference_id => @conference.id).first
    @registered = true
    if @registration.nil?
      @registered = false
      @registration = @person.registrations.new(:conference_id => @conference.id)
    end

    # Check if there's an existing SupporterRegistration for this email and link it when appropriate
    @registration.supporter_registration ||= @conference.supporter_registrations.where(:email => @person.email).first
    @registration.supporter_registration ||= SupporterRegistration.new(:conference_id => @conference.id)
  end

  # TODO this is ugly
  def update
    conference = Conference.find_by(short_title: params[:id])
    person = current_user.conference_person
    registration = person.registrations.where(:conference_id => conference.id).first
    update_registration = true
    # First verify that the supporter code is legit
    if !params[:registration][:supporter_registration_attributes].nil? && !params[:registration][:supporter_registration_attributes][:code].empty?
      regs = conference.supporter_registrations.where(:code => params[:registration][:supporter_registration_attributes][:code])

      if regs.count != 0
        if regs.where(:email => person.email).count == 0
          redirect_to(register_conference_path(:id => conference.short_title), :alert => "This code is already in use.  Please contact #{conference.contact_email} for assistance.")
          return
        end
      end
    end
    begin
      if registration.nil?
        update_registration = false
        person.update_attributes(registration_params[:conference_person_attributes])
        params[:registration].delete :conference_person_attributes
        supporter_reg = params[:registration][:supporter_registration_attributes]
        params[:registration].delete :supporter_registration_attributes
        registration = person.registrations.new(registration_params)
        if conference.use_supporter_levels? && !supporter_reg.nil?
          if !supporter_reg[:id].blank?
            # This means that their supporter registration was entered ahead of time, probably by an admin
            registration.supporter_registration = SupporterRegistration.find(supporter_reg[:id])
            if registration.supporter_registration.email != person.email
              raise "Invalid code"
            end
          else
            registration.supporter_registration = conference.
                supporter_registrations.new(registration_params[:supporter_registration_attributes])
          end
        end

        registration.conference_id = conference.id
        registration.save!
      else
        registration.update_attributes!(registration_params)
      end
    rescue Exception => e
      Rails.logger.debug e.backtrace.join("\n")
      redirect_to(register_conference_path(:id => conference.short_title), :alert => 'Registration failed:' + e.message)
      return
    end

    redirect_message = "You are now registered."
    if update_registration
      redirect_message = "Registration updated."
    else
      if conference.email_settings.send_on_registration?
        Mailbot.registration_mail(conference, current_user.conference_person).deliver
      end
    end
    redirect_to(register_conference_path(:id => conference.short_title), :notice => redirect_message)
  end

  def unregister
    conference = Conference.find_by(short_title: params[:id])
    person = current_user.conference_person
    registration = person.registrations.where(:conference_id => conference.id).first
    registration.destroy
    redirect_to :root
  end

  protected

  def registration_params
    params.require(:registration).
        permit(
          :conference_id, :attending_social_events, :attending_with_partner,
          :using_affiliated_lodging, :arrival, :departure,
          :other_dietary_choice, :handicapped_access_required, :dietary_choice_id,
          :volunteer,
          social_event_ids: [],
          other_special_needs: [],
          vchoice_ids: [],
          qanswer_ids: [],
          qanswers_attributes: [],
          conference_person_attributes: [
            :id, :public_name, :mobile, :tshirt, :languages,
            :volunteer_experience],
          supporter_registration_attributes: [
            :id, :supporter_level_id, :code
          ])
  end
end
