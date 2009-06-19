class RatingsController < ApplicationController

  # rate the image by rateable type
  def rate
    rateable_class = params[:type]
    @rateable = rateable_class.constantize.find(params[:id])
    # TODO for testing find the first user
    @current_user ? @current_user = User.find(params[:user_id]) : @current_user = User.find(:first)
    @current_user.rate(@rateable, params[:rating])
  end
   
end
# You must set @current_user equal to whatever 'rater' will be rating this object.
# If it is a student doing the rating, then set "@current_user = Student.find(params[:student_id])".
# Remove the line below TODO.  This will grab the first User if no user_id param is passed in.
