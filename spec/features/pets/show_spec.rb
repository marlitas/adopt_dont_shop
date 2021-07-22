require 'rails_helper'

RSpec.describe 'the shelter show' do
  before(:each) do
    Shelter.destroy_all
    Pet.destroy_all

    @shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    @pet = Pet.create(name: 'Scrappy', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
    @doc = @shelter.pets.create!(name: 'Doc', age: 8, adoptable: true, breed: 'schnauzer')

    @application1 = Applicant.create!(name: 'Carina', street_address: '455 Cool Street', city: 'Portland', state: 'OR', zip_code: 23392, status: 'Approved')
  end
  it "shows the shelter and all it's attributes" do
    visit "/pets/#{@pet.id}"

    expect(page).to have_content(@pet.name)
    expect(page).to have_content(@pet.age)
    expect(page).to have_content(@pet.adoptable)
    expect(page).to have_content(@pet.breed)
    expect(page).to have_content(@pet.shelter_name)
  end

  it "allows the user to delete a pet" do
    visit "/pets/#{@pet.id}"

    click_on("Delete #{@pet.name}")

    expect(page).to have_current_path('/pets')
    expect(page).to_not have_content(@pet.name)
  end

  it 'displays adoptability according to application acceptance' do
    @application1.pets << @pet
    visit "/pets/#{@pet.id}"

    expect(page).to have_content('false')
  end
end
