require 'spec_helper'

describe PadmaAccount do
  before do
    PadmaAccount.stub(:find).with('a-name').and_return(PadmaAccount.new(name: 'a-name'))
  end

  describe "#migrated?" do
    describe "if account has a migrated_to_padma_on" do
      let(:padma_account){PadmaAccount.new(migrated_to_padma_on: Date.today)}
      it "returns true" do
        padma_account.migrated?.should be_true
      end
    end

    describe "if account does NOT have a migrated_to_padma_on" do
      let(:padma_account){PadmaAccount.new()}
      it "returns false" do
        padma_account.migrated?.should be_false
      end
    end
  end
end
