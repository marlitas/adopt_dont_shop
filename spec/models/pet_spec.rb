require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it {should have_many :pet_applicants}
    it {should have_many(:applicants).through(:pet_applicants)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)

    @application1 = Applicant.create!(name: 'Carina', street_address: '455 Cool Street', city: 'Portland', state: 'OR', zip_code: 23392, status: 'In Progress')

    @application2 = Applicant.create!(name: 'Evan', street_address: '1234 Sparky Lane', city: 'Portland', state: 'OR', zip_code: 23392, home_description: 'I like playing and throwing ball with dogs', status: 'In Progress')

    @application1.pets << [@pet_3, @pet_2]
    @application2.pets << [@pet_3, @pet_1]
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
        expect(Pet.adoptable).to_not eq([@pet_3])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
        expect(@pet_2.shelter_name).to eq('Aurora shelter')
      end
    end

    it 'can check if any applications have been approved for that pet' do
      expect(@pet_3.any_approved?(@pet_3.id)).to be(false)

      @application2.update!(status: 'Approved')
      expect(@pet_3.any_approved?(@pet_3.id)).to be(true)
    end

    it 'can grab applicant status' do
      pet_applicant = PetApplicant.find_by_parents(@pet_3.id, @application1.id)
      pet_applicant.update!(status: 'accept')

      expect(@pet_3.applicant_status(@application1.id)).to eq('accept')
    end
  end
end
