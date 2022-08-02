require 'rails_helper'

RSpec.describe Article, type: :model do
  it 'will create with all required parameters' do
    article = described_class.create({ title: 'A Title',
                                       body: 'This is a new body of text for the latest test article' })
    expect(article.valid?).to be(true)
  end

  it 'will create with all required parameters with a factory' do
    article = FactoryBot.build(:article)
    expect(article.valid?).to be(true)
  end

  it 'will not create without a title' do
    article = FactoryBot.build(:article, title: nil)
    expect(article).not_to be_valid
  end

  it 'has error without a title' do
    article = FactoryBot.build(:article, title: nil)
    article.valid?
    expect(article.errors.messages[:title]).to eq ['Missing a title...']
  end

  it 'will not create without a body' do
    article = FactoryBot.build(:article, body: nil)
    expect(article).not_to be_valid
  end

  it 'will not create article with less that 50 chars in body' do
    article = FactoryBot.build(:article, body: 'Too short...')
    expect(article).not_to be_valid
  end

  it 'will not create an article with a duplicate title' do
    @article = FactoryBot.create(:article)
    article_two = FactoryBot.build(:article, body: 'This is a new body of text for the latest test article')
    expect(article_two.valid?).to be(false)
  end

  # write a test that creates the article, + search for the article Id and expect it to be present...

  it 'is located by its title' do
    article = FactoryBot.create(:article)
    expect(described_class.find_by(title: 'An Article')).to eq article
  end
end
