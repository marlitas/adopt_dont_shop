class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.pending
    pending_applications = Applicant.where("status = 'pending'")
    pending_applications.flat_map do |app|
      app.associated_pets
    end.map do |pet|
      Shelter.find(pet.shelter_id)
    end.uniq
  end

  def associated_applications
    pets.flat_map do |pet|
      pet.pet_applicants
    end.flat_map do |pet_applicant|
      Applicant.find(pet_applicant.applicant_id)
    end
  end
end
