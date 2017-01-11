class ApplicantsController < ApplicationController
  before_action :check_access_domain


  def index
    @applicants = Applicant.all.order('created_at asc')
  end

  def new
  end

  def create
    Applicant.create!(applicant_params)  # 一行代码代替了原来的两行
    @message = "Created successfully!"   # why not @m? 降低代码可读性，不是一种好的取名方式
    render "applicants/bootbox.js.erb"
  end

  def edit
    @applicant = Applicant.find(params[:id])
  end

  def update
    applicant = Applicant.where('passport_number = ?', applicant_params[:passport_number]).last
    #applicant = Applicant.find_by(passport_number: applicant_params[:passport_number]) #passport_number是否应该是唯一的，是的话建议加索引
    applicant.update_attributes!(applicant_params)
    @message = "Updated successfully!"
    render "applicants/bootbox.js.erb"
  end


  def destroy
    applicant = Applicant.find(params[:id])
    applicant.destroy
    redirect_to applicants_path
  end

  private
  def applicant_params
    params.require(:applicant).permit(:name, :passport_number, :phone_number, :mail_address)
  end
end
