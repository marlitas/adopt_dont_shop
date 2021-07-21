require 'rails_helper'

RSpec.describe Applicant do
  describe 'relationships' do
    it {should have_many :pet_applicants}
    it {should have_many(:pets).through(:pet_applicants)}
  end

  describe 'validations' do
    it 'can default a status' do
      application1 = Applicant.create!(name: 'Carina', street_address: '455 Cool Street', city: 'Portland', state: 'OR', zip_code: 23392, home_description: 'I love my furry friends and have a great yard they can roam around in')

      expect(application1.status).to eq('In Progress')

      application2 = Applicant.create!(name: 'Evan', street_address: '455 Cool Street', city: 'Portland', state: 'OR', zip_code: 23392, home_description: 'Im cool', status: 'Pending')

      expect(application2.status).to eq('Pending')
    end
  end

  describe 'instance methods' do
    it 'can list associated pet names' do
      furry = Shelter.create!(name:'Furrry Shelter', foster_program: true, city: 'New Orleans', rank: 5)

      lana = furry.pets.create!(name: 'Lana', age: 1, adoptable: true, breed: 'short-haired')
      doc = furry.pets.create!(name: 'Doc', age: 8, adoptable: true, breed: 'schnauzer')

      application1 = Applicant.create!(name: 'Carina', street_address: '455 Cool Street', city: 'Portland', state: 'OR', zip_code: 23392, home_description: 'I love my furry friends and have a great yard they can roam around in', status: 'pending')

      application1.pets << [lana, doc]

      expect(application1.associated_pets(application1.id)).to eq([lana, doc])
    end
  end
end
