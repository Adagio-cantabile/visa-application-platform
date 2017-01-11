class VisasController < ApplicationController
  before_action :check_access_domain, except: [:search, :index]

  def index
  end

  def search
    applicant = Applicant.where("name = ? and passport_number = ?", params[:name].upcase, params[:passport_number].upcase).first
    if applicant.present?
      @visas = applicant.visas
    else
      @e = "No record found, check your name and passport number again"
    end
  end

  def management
    @visas = Visa.all
  end

  def new
    @visa_country_type = Visa::SUCCESSFUL_VISA
  end

  def create
    applicant = Applicant.where('passport_number = ?', visa_params[:passport_number].upcase).last
    visa = Visa.new
    visa.applicant_id = applicant.id
    visa.country_abbr = visa_params[:country_abbr]
    visa.visa_type = visa_params[:type]
    visa.save!
    Status.create!(status_code: 0, visa_id: visa.id, staff_id: current_staff.id)
    @message = 'created successfully'
  end

  def edit
    @visa = Visa.find(params[:id])
    current_staff.corporate.own?(visa: @visa)
  end

  def destroy
    visa = Visa.find(params[:id])
    current_staff.corporate.own?(visa: visa)
    visa.destroy
    redirect_to action: 'management'
  end

  def set_visa_type_options
    country = params[:country]
    types = Visa.visa_types(country)
    @type_options = []
    for i in 0...types.count
      @type_options[i] = [types[i], i]
    end
  end

  def check_applicant_info
    passport_number = params[:passport_number]
    @applicant = Applicant.where('passport_number = ?', passport_number).last
  end

  private
  def visa_params
    params.permit(:name, :passport_number, :phone_number, :mail_address, :country_abbr, :type)
  end

end
