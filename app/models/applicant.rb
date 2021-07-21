class Applicant < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validate :status_progress, on: :create
  has_many :pet_applicants
  has_many :pets, through: :pet_applicants

  def associated_pets(applicant_id)
    PetApplicant.where('applicant_id = ?', applicant_id).map do |join|
      Pet.find(join.pet_id)
    end
  end

  def status_progress
    if status.present?

    else
      self.status = 'In Progress'
    end
  end
end
