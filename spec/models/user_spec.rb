# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = {:name => "Example User",
             :email => "user@example.com",
             :password => "foobar",
             :password_confirmation => "foobar"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "name should not be longer than 50 symbols" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject existing email" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "should have right confirmation" do
      User.new(@attr.merge(:password_confirmation => "wrong")).should_not be_valid
    end

    it "should have password" do
      User.new(@attr.merge(:password => "")).should_not be_valid
    end

    it "password should have right length" do
      User.create!(@attr)
      short_pass_user = User.new(@attr.merge(:password => "aaaaa"))
      short_pass_user.should_not be_valid
      long_pass_user = User.new(@attr.merge(:password => "a"*41))
      long_pass_user.should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
    end

    it "should have salt" do
      @user.salt.should_not be_blank
    end
  end

  describe "authentication" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should authenticate if password right" do
      User.authenticate(@attr[:email], @attr[:password]).should == @user
    end

    it "should return nil if password wrong" do
      User.authenticate(@attr[:email], "wrong_pass").should be_nil
    end

    it "should return nil if email not exist" do
      User.authenticate("wrong@mail.ru", @attr[:password]).should be_nil
    end
  end
end
