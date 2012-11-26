require 'spec_helper'

describe CrushpathApi::UserResponse do

  context "with paid user" do
    before do
      @json = fixture('user-with-contact-paid.json', true)
      @resp = CrushpathApi::UserResponse.new(@json)
    end

    it "should be instantiable" do
      @json.should_not be_nil
      @resp.should_not be_nil
    end

    describe "get_company_name" do
      it "should get the name" do
        name = @resp.get_company_name
        name.should == "Crushpath"
      end
    end

    describe "get_company_description" do
      it "should get the description" do
        name = @resp.get_company_description
        name.should == "Always be closing"
      end
    end

    describe "phone" do
      it "should get the phone number digits" do
        phone = @resp.phone
        phone.should == "3104989407"
      end
    end

    describe "recommendations" do
      it "shows the recommendations" do
        recs = @resp.get_recommendations
        recs.count.should == 1
        recs.first['display_name'].should == "Wayne Inc"
      end
    end

    describe "company_website" do
      it "should add the http" do
        website = @resp.get_company_website
        website.should == "http://www.crushpath.com"
      end
    end

    describe "parse" do
      before do
        @user_hash = @resp.parse
      end

      it "should get the basics" do
        @user_hash.should_not be_nil
        @user_hash[:full_name].should == 'Tom Brady'
        @user_hash[:paid].should == true
        @user_hash[:nickname].should == 'TomBrady'
      end

      it "should get the company info" do
        @user_hash[:company].should == "Crushpath"
      end
    end

  end
end
