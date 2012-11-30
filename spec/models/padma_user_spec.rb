require 'spec_helper'

describe PadmaUser do

  before do
    PadmaAccount.stub(:find).with('a-name').and_return(PadmaAccount.new(name: 'a-name'))
  end

  let(:padma_user){PadmaUser.new(current_account_name: 'a-name')}

  describe "#current_account" do
    context "when account exists" do
      context "on first call" do
        it "returns a PadmaAccount" do
          padma_user.current_account.should be_a PadmaAccount
        end
        it "fetches from accounts-ws" do
          PadmaAccount.should_receive(:find).and_return PadmaAccount.new(name: 'a-name')
          padma_user.current_account
        end
        it "stores object on cached_current_account" do
          padma_user.cached_current_account.should be_nil
          padma_user.current_account
          padma_user.cached_current_account.should_not be_nil
        end
      end
      context "on sucesive calls" do
        it "returns a PadmaAccount" do
          padma_user.current_account
          padma_user.current_account.should be_a PadmaAccount
        end
        it "wont fetch from accounts-ws (cached on object)" do
          PadmaAccount.should_receive(:find).once.and_return PadmaAccount.new
          5.times { padma_user.current_account }
        end
      end
    end
  end

  context "default use_ssl" do
    before do
      Rails = mock(env: environment)
    end
    context "in production environment" do
      let(:environment){'production'}
      it "uses ssl" do
        PadmaAccount.resource_uri.should match /https/
      end
    end
    context "in staging environment" do
      let(:environment){'staging'}
      it "uses ssl" do
        PadmaAccount.resource_uri.should match /https/
      end
    end
    context "in development environment" do
      let(:environment){'development'}
      it "doesnt use ssl" do
        PadmaAccount.resource_uri.should_not match /https/
      end
    end
  end

  context "setting use_ssl = true" do
    before do
      PadmaAccount.use_ssl = true
      Rails = mock(env: environment)
    end
    context "in production environment" do
      let(:environment){'production'}
      it "uses ssl" do
        PadmaAccount.resource_uri.should match /https/
      end
    end
    context "in staging environment" do
      let(:environment){'staging'}
      it "uses ssl" do
        PadmaAccount.resource_uri.should match /https/
      end
    end
    context "in development environment" do
      let(:environment){'development'}
      it "uses ssl" do
        PadmaAccount.resource_uri.should match /https/
      end
    end
  end

  context "setting use_ssl = false" do
    before do
      PadmaAccount.use_ssl = false
      Rails = mock(env: environment)
    end
    context "in production environment" do
      let(:environment){'production'}
      it "doesnt use ssl" do
        PadmaAccount.resource_uri.should_not match /https/
      end
    end
    context "in staging environment" do
      let(:environment){'staging'}
      it "doesnt use ssl" do
        PadmaAccount.resource_uri.should_not match /https/
      end
      example{ Rails.env == 'staging' }
    end
    context "in development environment" do
      let(:environment){'development'}
      it "doesnt use ssl" do
        PadmaAccount.resource_uri.should_not match /https/
      end
      example{ Rails.env == 'development' }
    end
  end

end