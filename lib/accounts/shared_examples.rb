shared_examples_for "it belongs to an account"  do
  it { should validate_presence_of :account_name }
  it "should return account on #account" do
    PadmaAccount.should_receive(:find).with(object.account_name).and_return(PadmaAccount.new(account_name: object.account_name))
    object.account.should be_a(PadmaAccount)
  end
end

shared_examples_for "it belongs to a user"  do
  it { should validate_presence_of :username}
  it "should return user on #user" do
    PadmaUser.should_receive(:find).with(object.username).and_return(PadmaUser.new(username: object.username))
    object.user.should be_a(PadmaUser)
  end
  it "should use Rails.cache"
end