require 'rails_helper'

RSpec.describe Applicant do
  describe 'relationships' do
    it {should have_many :pet_applicants}
    it {should have_many(:pets).through(:pet_applicants)}
  end

  describe 'validations' do
    it{should validate_presence_of(:name)}
    it{should validate_presence_of(:street_address)}
    it{should validate_presence_of(:city)}
    it{should validate_presence_of(:state)}
    it{should validate_presence_of(:zip_code)}
    it{should validate_presence_of(:home_description).on(:submit)}

    it 'can default a status' do
      application1 = Applicant.create!(name: 'Carina', street_address: '455 Cool Street', city: 'Portland', state: 'OR', zip_code: 23392, home_description: 'I love my furry friends and have a great yard they can roam around in')

      expect(application1.status).to eq('In Progress')

      application2 = Applicant.create!(name: 'Evan', street_address: '455 Cool Street', city: 'Portland', state: 'OR', zip_code: 23392, home_description: 'Im cool', status: 'Pending')

      expect(application2.status).to eq('Pending')
    end
  end

  describe 'instance methods' do
    before (:each) do
      @furry = Shelter.create!(name:'Furrry Shelter', foster_program: true, city: 'New Orleans', rank: 5)

      @lana = @furry.pets.create!(name: 'Lana', age: 1, adoptable: true, breed: 'short-haired')
      @doc = @furry.pets.create!(name: 'Doc', age: 8, adoptable: true, breed: 'schnauzer')

      @application1 = Applicant.create!(name: 'Carina', street_address: '455 Cool Street', city: 'Portland', state: 'OR', zip_code: 23392, home_description: 'I love my furry friends and have a great yard they can roam around in', status: 'pending')

      @application1.pets << [@lana, @doc]

      @pet_application1 = PetApplicant.find_by_parents(@lana.id, @application1.id)
      @pet_application2 = PetApplicant.find_by_parents(@doc.id, @application1.id)
    end

    it 'can list associated pet names' do
      expect(@application1.associated_pets(@application1.id)).to eq([@lana, @doc])
    end

    it 'can approve application' do
      @pet_application1.update!(status: 'approve')
      @pet_application2.update!(status: 'approve')

      expect(@application1.approved?(@application1.id)).to be(true)
    end

    it 'can reject application' do
      @pet_application1.update!(status: 'approve')
      @pet_application2.update!(status: 'reject')

      expect(@application1.approved?(@application1.id)).to be(false)
    end

    it 'can determine if all pet statuses on application have been decided' do
      @pet_application2.update!(status: 'approve')

      expect(@application1.all_decided?(@application1.id)).to be(false)

      @pet_application1.update!(status: 'approve')

      expect(@application1.all_decided?(@application1.id)).to be(true)

      @pet_application1.update!(status: 'reject')

      expect(@application1.all_decided?(@application1.id)).to be(true)
    end
  end
end
