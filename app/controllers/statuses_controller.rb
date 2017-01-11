class StatusesController < ApplicationController
  before_action :check_access_domain

  def create
    visa = Visa.find(status_params[:visa_id])
    if status_params[:success]
      status = Status.new(visa_id: visa.id, status_code: 5, staff_id: current_staff.id)
      status.save!
    elsif status_params[:rejected]
      status = Status.new(visa_id: visa.id, status_code: 6, staff_id: current_staff.id)
      status.save!
    else
      current_status = Status.find(status_params[:current_status_id])
      current_status_code = current_status.status_code
      next_status_index = visa.successful_process.index(current_status_code) + 1
      next_status_code = visa.successful_process[next_status_index]
      Status.create!(visa_id: visa.id, status_code: next_status_code, staff_id: current_staff.id)
    end
    visa.reload
    @visas = Visa.all
    render 'visas/refresh_management_table.js.erb'
  end

  private
  def status_params
    params.permit(:visa_id, :current_status_id, :success, :rejected)
  end
end
