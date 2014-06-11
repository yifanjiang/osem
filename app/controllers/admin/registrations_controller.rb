class Admin::RegistrationsController < ApplicationController
  before_filter :verify_organizer

  def index
    session[:return_to] ||= request.referer
    @pdf_filename = "#{@conference.title}.pdf"
    @registrations = @conference.registrations.includes(:user).order("registrations.created_at ASC")
    @attended = @conference.registrations.where("attended = ?", true).count
    @headers = %w[name email nickname other_needs arrival departure attended]
  end

  def change_field
      @registration = Registration.find(params[:id])
      field = params[:view_field]
      if @registration.send(field.to_sym)
        @registration.update_attribute(:"#{field}",0)
      else
        @registration.update_attribute(:"#{field}",1)
      end

      redirect_to admin_conference_registrations_path(@conference.short_title)
      flash[:notice] = "Updated '#{params[:view_field]}' => #{@registration.attended} for
                        #{(User.where("id = ?", @registration.user_id).first).email}"
  end

  def edit
    @registration = @conference.registrations.where("id = ?", params[:id]).first
    @user = User.where("id = ?", @registration.user_id).first
  end

  def update
    @registration = @conference.registrations.where("id = ?", params[:id]).first
    @user = User.where("id = ?", @registration.user_id).first
    begin
      @user.update_attributes!(params[:registration][:user_attributes])
      params[:registration].delete :user_attributes
      if params[:registration][:supporter_registration]
        @registration.supporter_registration.update_attributes(params[:registration][:supporter_registration_attributes])
        params[:registration].delete :supporter_registration_attributes
      end
      @registration.update_attributes!(params[:registration])
      flash[:notice] = "Successfully updated registration for #{@user.name} #{@user.email}"
      redirect_to(admin_conference_registrations_path(@conference.short_title))
    rescue Exception => e
      Rails.logger.debug e.backtrace.join("\n")
      redirect_to(admin_conference_registrations_path(@conference.short_title),
                  alert: 'Failed to update registration:' + e.message)
      return
    end
  end

  def new
    @user = User.new
    @registration = @user.registrations.new
    @supporter_registration = @conference.supporter_registrations.new
    @conference = Conference.find_by(short_title: params[:conference_id])
  end

  def create
    @conference = Conference.find_by(short_title: params[:conference_id])
    email = params[:registration][:user][:email]
    @user = User.find_by_email email
    @registration = nil

    if @user
      if @user.registrations.where(conference_id: @conference).empty?
        @user.attributes = params[:registration][:user] # Should we really modify user information?
      else
        redirect_to admin_conference_registrations_path(@conference.short_title)
        flash[:notice] = "#{@user.email} is already registred!"
        return
      end
    else
      @user = User.new params[:registration][:user]
    end

    if @user.new_record?
      @user.password = rand(36**6).to_s(36)
      @user.skip_confirmation!
    end
    @user.email = email

    @registration = @user.registrations.build
    if params[:registration][:supporter_registration]
      @supporter_registration = @registration.build_supporter_registration
      @supporter_registration.attributes = params[:registration][:supporter_registration]
      @supporter_registration.conference_id = @conference.id
    else
      @supporter_registration = @conference.supporter_registrations.new
    end
    params[:registration].delete :user
    params[:registration].delete :user
    params[:registration].delete :supporter_registration
    @registration.attributes = params[:registration]
    @registration.conference_id = @conference.id
    @registration.attended = true
    begin
      Registration.transaction do
        @user.save!
        @registration.save!
      end
      flash[:notice] = "Successfully created new registration for #{@user.email}."
      redirect_to admin_conference_registrations_path(@conference.short_title)
    rescue ActiveRecord::RecordInvalid
      render action: "new"
    end
  end

  def destroy
    if has_role?(current_user, "Admin")
      registration = @conference.registrations.where(:id => params[:id]).first
      user = User.where("id = ?", registration.user_id).first
      
      begin registration.destroy
        redirect_to admin_conference_registrations_path
        flash[:notice] = "Deleted registration for #{user.name} #{user.email}"
      rescue Exception => e
        Rails.logger.debug e.backtrace.join("\n")
        redirect_to(admin_conference_registrations_path(@conference.short_title),
	            alert: 'Failed to delete registration:' + e.message)
        return
      end
    else
      redirect_to(admin_conference_registrations_path(@conference.short_title),
                  alert: 'You must be an admin to delete a registration.')
    end
  end
end