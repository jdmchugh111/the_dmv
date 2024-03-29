require 'spec_helper'
require 'date'

RSpec.describe Facility do
  before(:each) do
    @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
    @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility_1).to be_an_instance_of(Facility)
      expect(@facility_1.name).to eq('DMV Tremont Branch')
      expect(@facility_1.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
      expect(@facility_1.phone).to eq('(720) 865-4600')
      expect(@facility_1.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility_1.services).to eq([])
      @facility_1.add_service('New Drivers License')
      @facility_1.add_service('Renew Drivers License')
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  it "defaults to empty array when no vehicles have been registered" do
    expect(@facility_1.registered_vehicles).to eq([])
  end

  it "defaults to zero when no fees have been collected" do
    expect(@facility_1.collected_fees).to eq(0)
  end

  it "can register a vehicle" do
    @facility_1.add_service("Vehicle Registration")
    expect(@facility_1.register_vehicle(@cruz)).to eq([@cruz])
  end

  it "will only register a vehicle if facility offers Vehicle Registration" do
    @facility_1.add_service("Vehicle Registration")
    expect(@facility_1.register_vehicle(@cruz)).to eq([@cruz])
  end

  it "won't register a car if facility doesn't offer Vehicle Registration" do
    expect(@facility_1.register_vehicle(@cruz)).to eq(nil)
    expect(@facility_2.register_vehicle(@cruz)).to eq(nil)
  end

  it "can create a registration date" do
    @facility_1.add_service("Vehicle Registration")
    @facility_1.register_vehicle(@cruz)
    expect(@cruz.registration_date).to eq(Date.today)
  end

  it "collects $25 for antique vehicles" do
    @facility_1.add_service("Vehicle Registration")
    @facility_1.register_vehicle(@camaro)

    expect(@facility_1.collected_fees).to eq(25)
  end

  it "collects $200 for electric vehicles" do
    @facility_1.add_service("Vehicle Registration")
    @facility_1.register_vehicle(@bolt)

    expect(@facility_1.collected_fees).to eq(200)
  end

  it "collects $100 for regular vehicles" do
    @facility_1.add_service("Vehicle Registration")
    @facility_1.register_vehicle(@cruz)

    expect(@facility_1.collected_fees).to eq(100)
  end

  it "will return sum of collected_fees after multiple registrations" do
    @facility_1.add_service("Vehicle Registration")
    @facility_1.register_vehicle(@cruz)
    @facility_1.register_vehicle(@bolt)
    @facility_1.register_vehicle(@camaro)

    expect(@facility_1.collected_fees).to eq(325)
  end

  it "stores all registered vehicles" do
    @facility_1.add_service("Vehicle Registration")
    @facility_1.register_vehicle(@cruz)
    @facility_1.register_vehicle(@bolt)
    @facility_1.register_vehicle(@camaro)

    expect(@facility_1.registered_vehicles).to eq([@cruz, @bolt, @camaro])
  end

  it "can sort vehicles into plate types once registered" do
    @facility_1.add_service("Vehicle Registration")
    @facility_1.register_vehicle(@cruz)
    @facility_1.register_vehicle(@bolt)
    @facility_1.register_vehicle(@camaro)

    expect(@cruz.plate_type).to eq(:regular)
    expect(@bolt.plate_type).to eq(:ev)
    expect(@camaro.plate_type).to eq(:antique)
  end

  it "will assign nil plate_type for unregistered vehicles" do
    @facility_1.add_service("Vehicle Registration")

    expect(@cruz.plate_type).to eq(nil)
  end

end
