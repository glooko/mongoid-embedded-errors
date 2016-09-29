RSpec.describe Mongoid::EmbeddedErrors do
  describe '#errors_with_embedded_errors' do
    subject(:article) { Article.new name: 'Test', summary: '-', pages: pages }
    before { |spec| article.validate unless spec.metadata[:do_not_validate] }

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
    context 'when all pages in article are valid' do
      let(:pages) { [Page.new(title: 'First page')] }

      it { is_expected.to be_valid }
    end
    context 'when embedded document has not been validated', :do_not_validate do
      let(:pages) { [Page.new] }

      it 'does not trigger validations' do
        expect(article.errors).to be_empty
      end
    end
  end
end
