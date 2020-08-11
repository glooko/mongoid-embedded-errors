# frozen_string_literal: true

RSpec.describe Mongoid::EmbeddedErrors do
  describe '#errors_with_embedded_errors' do
    subject(:article) { Article.new name: 'Test', summary: '-', pages: pages }

    before { |spec| article.validate unless spec.metadata[:do_not_validate] }

    context 'when module is already included in a class', :do_not_validate do
      let(:dummy_class) do
        Class.new do
          include Mongoid::Document
          include Mongoid::EmbeddedErrors
        end
      end

      it 'does not create errors_without_embedded_errors alias again' do
        a = dummy_class.instance_method(:errors_without_embedded_errors)
        dummy_class.include described_class

        expect(a).to eq(dummy_class.instance_method(:errors_without_embedded_errors))
      end
    end

    context 'when article does not have any pages associated' do
      let(:pages) { [] }

      it { is_expected.not_to be_valid }

      it "returns `can't be blank` error for pages" do
        expect(article.errors[:pages]).to include "can't be blank"
      end
    end

    context 'when article has one or more invalid pages' do
      let(:pages) { [Page.new] }

      it { is_expected.not_to be_valid }

      it 'does not have any errors under `:pages` key' do
        expect(article.errors[:pages]).to be_empty
      end

      it 'returns all errors for `pages[0]` object' do
        expect(article.errors[:'pages[0].title']).to include "can't be blank"
      end
    end

    context 'when validated multiple times' do
      let(:pages) { [Page.new] }

      it 'does not have duplicated errors for the same object' do
        article.valid?
        expect(article.errors[:'pages[0].title']).to eq(["can't be blank"])
      end
    end

    context 'when embeds_many relation is invalid' do
      let(:pages) { [Page.new(title: 'Test page', sections: sections)] }
      let(:sections) { [Section.new] }

      it 'returns all errors for `sections[0]` object' do
        expect(article.errors[:'pages[0].sections[0].header']).to include "can't be blank"
      end
    end

    context 'when embeds_one relation is invalid' do
      subject(:article) { Article.new name: 'Test', summary: '-', pages: pages, annotation: annotation }

      let(:pages) { [Page.new(title: 'Test page')] }
      let(:annotation) { Annotation.new }

      it 'returns all errors for `annotation` object' do
        expect(article.errors[:'annotation.text']).to include "can't be blank"
      end
    end

    context 'when embedded document has not been validated', :do_not_validate do
      let(:pages) { [Page.new] }

      it 'does not trigger validations' do
        expect(article.errors).to be_empty
      end
    end
  end
end
