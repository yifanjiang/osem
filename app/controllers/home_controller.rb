class HomeController < ApplicationController
  def index
    @today = Date.current
    @current = Conference.where("end_date >= ?", @today).order("start_date ASC")

    @profile = nil
    if current_user
      @profile = current_user.person
    end
  end
end
