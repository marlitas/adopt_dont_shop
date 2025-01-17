class ApplicantsController < ApplicationController
  def show
    @search_pets = []
    @application = Applicant.find(params[:id])
    unless params[:search].nil?
      @search_pets = Pet.search(params[:search])
    end
  end

  def new
  end

  def create
    application = Applicant.new(applicant_params)
    if application.save
      redirect_to "/applicants/#{application.id}"
    else
      flash[:notice] = 'Application not created: Required information missing.'
      redirect_to '/applicants/new'
    end
  end

  def update
    application = Applicant.find(params[:id])
    pet = Pet.find(params[:pet_id])
    application.pets << pet

    redirect_to "/applicants/#{application.id}"
  end

  def submit
    application = Applicant.find(params[:id])
    application[:home_description] = params[:home_description]
    application[:status] = 'Pending'
    application.save!(context: :submit)
    redirect_to "/applicants/#{application.id}"
  end

  def applicant_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :home_description)
  end
end
