require 'rails_helper'

RSpec.describe Card, type: :model do
  subject { FactoryGirl.build :card }

  describe :validations do
    it { should validate_presence_of(:card_type) }
    it { is_expected.to define_enum_for(:card_type).with([:credit, :debit]) }
    it { is_expected.to define_enum_for(:status).with([:active, :removed]) }
    it { should validate_presence_of(:last_4) }
    it { should validate_length_of(:last_4).is_equal_to(4) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:expiration) }
  end

  describe :associations do
    it { is_expected.to belong_to(:user) }
  end

  describe :callbacks do
    it "should override expiration day" do
      subject.save!
      expect(subject.reload.expiration.strftime("%d")).to eq("01")
    end

    it "should enable card before create" do
      subject.save!
      expect(subject.active?).to be true
    end
  end

  describe :scopes do
    before :each do
      4.times do |n|
        if n.odd?
          FactoryGirl.create(:card, expiration: 1.month.ago)
        else
          FactoryGirl.create(:card)
        end
      end
    end
    it "should have an expired scope" do
      expect(Card).to respond_to(:expired)
    end
    it "returns only expired records" do
      expect(Card.expired.count).to eq(2)
    end
  end
end
