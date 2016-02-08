class Api::V1::Admin::SemestersController < Api::V1::Admin::BaseController
  before_filter :authenticate_president!

  load_and_authorize_resource

  def create
    if @semester.save
      render json: @semester, serializer: SemesterSerializer
    else
      error_response(@semester)
    end
  end

  def finish
    if @semester.update_attributes(finish_params)
      @semester.finish_semester
      render json: @semester, serializer: SemesterSerializer
    else
      error_response(@semester)
    end
  end

  private

  def semester_params
    params.require(:semester).permit(:start, :season)
  end

  def finish_params
    params.require(:semester).permit(:finish)
  end

  def authenticate_president!
    unless current_user.president?
      unauthorized_response
    end
  end
end
