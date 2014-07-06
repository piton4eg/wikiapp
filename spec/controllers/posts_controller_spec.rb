require 'rails_helper'

describe PostsController do
  describe "root page" do
    it "assigns hash tree" do
      create(:post)
      get :index
      expect(response.code.to_i).to eq 200
      expect(assigns(:tree_posts)).to eq(Post.hash_tree)
    end
  end

  describe "GET show" do
    it "assigns post as @post" do
      post = create(:post)
      get :show, ancestry_path: post.ancestry_path_params
      expect(assigns(:post)).to eq(post)
    end

    it "assigns child post as @post" do
      post = create(:post)
      child = post.add_child(create(:post))
      get :show, ancestry_path: child.ancestry_path_params
      expect(assigns(:post)).to eq(child)
    end
  end

  describe "GET new" do
    it "assigns a new post as @post" do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end

    it "assigns a new child post as @post" do
      parent = create(:post)
      get :new, ancestry_path: parent.ancestry_path_params
      expect(assigns(:post)).to be_a_new(Post)
    end

    it "not found post" do
      expect {
        get :new, ancestry_path: 'invalid/url'
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET edit" do
    it "assigns the requested post as @post" do
      post = create(:post)
      get :edit, ancestry_path: post.ancestry_path_params
      expect(assigns(:post)).to eq(post)
    end

    it "assigns child post as @post" do
      post = create(:post)
      child = post.add_child(create(:post))
      get :edit, ancestry_path: child.ancestry_path_params
      expect(assigns(:post)).to eq(child)
    end

    it "not found post" do
      expect {
        get :edit, ancestry_path: 'invalid/url'
      }.to raise_error(ActionController::RoutingError)
    end
  end

  let(:valid_attributes) { attributes_for(:post) }
  let(:invalid_attributes) { attributes_for(:post, name: '') }

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Post" do
        expect {
          post :create, post: valid_attributes
        }.to change(Post, :count).by(1)
      end

      it "assigns a newly created post as @post" do
        post :create, post: valid_attributes
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
      end

      it "assigns a newly created child post as @post" do
        parent = create(:post)
        post :create, post: valid_attributes, ancestry_path: parent.ancestry_path_params
        expect(assigns(:post)).to eq(parent.reload.children.last)
      end

      it "redirects to the created post" do
        post :create, post: valid_attributes
        expect(response).to redirect_to(Post.last.post_url)
      end

      it "not found post" do
        expect {
          get :create, post: valid_attributes, ancestry_path: 'invalid/url'
        }.to raise_error(ActionController::RoutingError)
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        post :create, post: invalid_attributes
        expect(assigns(:post)).to be_a_new(Post)
      end

      it "re-renders the 'new' template" do
        post :create, post: invalid_attributes
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) { attributes_for(:post, name: 'NewName', 
                                                   title: 'New Title',
                                                   text: 'New Text') }

      it "updates the requested post" do
        post = create(:post)
        put :update, ancestry_path: post.ancestry_path_params, post: new_attributes
        post.reload
        expect(post.name).to eq 'NewName'
        expect(post.title).to eq 'New Title'
        expect(post.text).to eq 'New Text'
      end

      it "redirects to the post" do
        post = create(:post)
        put :update, ancestry_path: post.ancestry_path_params, post: new_attributes
        expect(response).to redirect_to(post.reload.post_url)
      end

      it "not found post" do
        expect {
          get :update, ancestry_path: 'invalid/url', post: new_attributes
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "with invalid params" do
      it "assigns the post as @post" do
        post = create(:post)
        put :update, ancestry_path: post.ancestry_path_params, post: invalid_attributes
        expect(assigns(:post)).to eq(post)
      end

      it "re-renders the 'edit' template" do
        post = create(:post)
        put :update, ancestry_path: post.ancestry_path_params, post: invalid_attributes
        expect(response).to render_template("edit")
      end
    end
  end
end
