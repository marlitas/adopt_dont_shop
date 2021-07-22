class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :pet_applicants
  has_many :applicants, through: :pet_applicants

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def any_approved?(pet_id)
    pet_applicants = PetApplicant.where(pet_id: pet_id)
    pet_applicants.any? do |applicant|
      Applicant.find(applicant.applicant_id).status == 'Approved'
    end
  end

  def set_adoptable(pet_id)

  end

  def all_applicants

  end
end
