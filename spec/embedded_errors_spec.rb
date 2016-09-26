describe Mongoid::EmbeddedErrors do
  let(:article) { Article.new }
  let(:invalid_page) { Page.new }
  let(:valid_page) { Page.new title: 'test' }
  let(:invalid_section) { Section.new }
  let(:valid_section) { Section.new(header: 'My Header') }
  let(:invalid_annotation) { Annotation.new }

  describe 'errors' do
    it 'bubbles up errors from embedded documents' do
      invalid_page.sections << valid_section
      invalid_page.sections << invalid_section
      article.pages << invalid_page
      article.annotation = invalid_annotation
      article.should_not be_valid
      article.errors.messages.should eql(
        name: ["can't be blank"],
        summary: ["can't be blank"],
        :"pages[0].title" => ["can't be blank"],
        :"pages[0].sections[1].header" => ["can't be blank"],
        :"annotation.text" => ["can't be blank"]
      )
    end

    it 'save works as before' do
      article.pages << valid_page
      expect(article.save).to be false
      article.should_not be_persisted
      article.errors.messages.should eql(
        name: ["can't be blank"], summary: ["can't be blank"]
      )
    end
    it 'handles errors on the main object' do
      article.should_not be_valid
      article.errors.messages.should eql(
        name: ["can't be blank"],
        summary: ["can't be blank"],
        pages: ["can't be blank"]
      )
    end
    it 'does not remove other validation errors from relational fields' do
      article.validate
      expect(article.errors[:pages]).to include "can't be blank"
    end
  end
end
