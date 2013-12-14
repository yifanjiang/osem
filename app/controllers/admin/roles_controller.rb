class Admin::RolesController < ApplicationController

  def show
    @conference = Conference.find_all_by_short_title(params[:conference_id]).first
    render :roles_list
  end

  def update
    begin
      @conference = Conference.find_all_by_short_title(params[:conference_id]).first
      redirect_to(admin_conference_roles_path(:conference_id => @conference.short_title), :notice => 'Roles were successfully updated.')
    rescue Exception => e
      redirect_to(admin_conference_roles_path(:conference_id => @conference.short_title), :alert => "Roles update failed: #{e.message}")
    end
  end
end
