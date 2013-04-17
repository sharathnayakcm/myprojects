require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "Login" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Login,'testuser'
    end

    it "should process Login query" do
      pending
    end

    it "should process Login create" do
      pending
    end

    it "should process Login update" do
      pending
    end

    it "should process Login delete" do
      pending
    end
  end  
end