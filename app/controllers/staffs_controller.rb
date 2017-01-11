class StaffsController < ApplicationController
  before_action :check_access_domain

  def index
    @staffs = current_staff.corporate.staffs
  end

  def new
  end

  def create
    staff = Staff.new(staff_params)
    staff.corporate_id = current_staff.corporate_id
    staff.save!
    @message = 'Created successfully'
    render 'bootbox.js.erb'
  end

  def edit
  end

  def update
    staff = Staff.find(params[:id])
    current_staff.corporate.own?(staff)
    if staff_params[:password].present?
      staff.password = staff_params[:password]
      staff.password_confirmation = staff_params[:password_confirmation]
      staff.password_digest = BCrypt::Password.create(staff_params[:password], cost: 5)
    end
    staff.name = staff_params[:name]
    p staff
    staff.save!
    @message = 'Updated successfully'
    render 'bootbox.js.erb'
  end

  def destroy
    staff = Staff.find(params[:id])
    staff.destroy
    redirect_to staffs_path
  end

  def staff_params
    params.require(:staff).permit(:password, :password_confirmation, :name, :user_name, :domain)
  end
end
