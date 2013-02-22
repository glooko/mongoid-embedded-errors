require 'spec_helper'

describe Mongoid::EmbeddedErrors do

  let(:article) { Article.new }
  let(:invalid_page) { Page.new }
  let(:invalid_section) { Section.new }
  let(:valid_section) { Section.new(header: "My Header") }

  describe "errors" do

    it "bubbles up errors from embedded documents" do
      invalid_page.sections << valid_section
      invalid_page.sections << invalid_section
      article.pages << invalid_page
      article.should_not be_valid
      article.errors.messages.should eql({
        name: ["can't be blank"],
        summary: ["can't be blank"],
        :"pages[0].title" => ["can't be blank"],
        :"pages[0].sections[1].header" => ["can't be blank"]
      })
    end

    it "save works as before" do
      article.save.should be_false
      article.should_not be_persisted
      article.errors.messages.should eql(name: ["can't be blank"], summary: ["can't be blank"])
    end

    it "handles errors on the main object" do
      article.should_not be_valid
      article.errors.messages.should eql(name: ["can't be blank"], summary: ["can't be blank"])
    end

  end

end
