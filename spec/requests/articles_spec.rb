require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  describe 'GET /articles' do
    before do
      get articles_path
    end

    it 'returns HTTP 200 status code' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'POST /articles' do
    it 'create article, has http status code 302' do
      post articles_path params: { article: { title: 'Testing',
                                              body: 'This is a new body of text for the latest test article' } }
      expect(response).to have_http_status(:found)
      follow_redirect!
      expect(response).to render_template(:show)
    end

    it 'fails to create the article without required parameters' do
      post articles_path params: { article: { title: 'Testing' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /articles/new' do
    before do
      get new_article_path
    end

    it 'returns HTTP 200 status' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the new article template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /articles/:id/edit' do
    let!(:article) do
      Article.create({ title: 'Test',
                       body: 'This is a body is a body is a body is a booodyyyyy' })
    end

    before do
      get edit_article_path(article)
    end

    it 'returns HTTP 200 status' do
      expect(response).to have_http_status(:success)
    end

    it 'renders edit page' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET /articles/:id' do
    let!(:article) do
      Article.create({ title: 'Test',
                       body: 'This is a body is a body is a body is a booodyyyyy' })
    end

    it 'returns HTTP 200 status' do
      get article_path(article)
      expect(response).to have_http_status(:success)
    end

    it 'returns the show template' do
      get article_path(article)
      expect(response).to render_template(:show)
    end
  end

  describe 'PUT /articles/:id' do
    let!(:article) do
      Article.create({ title: 'Test',
                       body: 'This is a body is a body is a body is a booodyyyyy' })
    end

    let(:article_params) do
      {
        title: 'Testing #2',
        body: 'This is another body...this is another body...body another is this'
      }
    end
    let(:invalid_article) do
      {
        body: 'This is another body...body another is this...'
      }
    end

    context 'with valid parameters' do
      before do
        put "/articles/#{article.id}", params: { article: article_params }
        article.reload
      end

      it 'finds the updated article' do
        expect(response).to have_http_status(:found)
        expect(article.title).to eq 'Testing #2'
      end

      it 'renders the show template' do
        follow_redirect!
        expect(response).to render_template(:show)
      end
    end

    context 'with invalid parameters' do
      before do
        put "/articles/#{article.id}", params: { article: invalid_article }
      end

      it 'fails at updating the article' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH /articles/:id' do
    let!(:article) do
      Article.create({ title: 'Testing',
                       body: 'This is a body this is a body is a body is a this...' })
    end

    it 'updates the article' do
      patch article_url(article), params: { article: { title: 'Test #2' } }
      article.reload
      expect(response).to have_http_status(:found)
      expect(article.title).to eq 'Test #2'
    end
  end

  describe 'DELETE /articles/:id' do
    let!(:article) do
      Article.create({ title: 'Testing',
                       body: 'This is a body this is a body is a body is a this...' })
    end

    it 'deletes article, redirects to index' do
      delete article_path(article)
      expect(response).to have_http_status(:see_other)
      follow_redirect!
      expect(response).to render_template(:index)
    end
  end
end
