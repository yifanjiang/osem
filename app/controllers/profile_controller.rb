class ProfileController < ApplicationController
  before_filter :verify_user

  def new
    profile = @conference.people.where("people.user_id =?", current_user.id).first

    if !profile.nil?
      redirect_to edit_conference_profile_path(@conference.short_title, profile.id)
    else
      @profile = @conference.people.new
    end

  end

  def create
    @profile = @conference.people.new
    @profile.user_id = current_user.id
    @profile.email = current_user.email

    if @profile.update_attributes!(params[:person])
      redirect_to(conference_path(@conference.short_title),
                  notice: "Successfully created conference profile for #{@conference.short_title}.")
    else
      flash[:alert] = "error, #{@profile.errors.full_messages.join('. ')}."
      render 'new'
    end
  end

  def edit
    if !@conference.people.where("people.user_id = ?", current_user.id).first.nil?
      @profile = @conference.people.where("people.user_id = ?", current_user.id).first
    else
      @profile = @conference.people.new
    end
  end

  def update
    @profile = Person.find(params[:id])

    if @profile.update_attributes(params[:person])
      redirect_to(conference_path(@conference.short_title),
                  notice: "Successfully updated conference profile for #{@conference.short_title}.")
    else
      flash[:error] = "Not successful update! #{@profile.errors.full_messages.join('. ')}."
      render action: 'edit'
    end
  end

end