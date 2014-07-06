require 'rails_helper'

describe Post do
  let(:post) { create(:post) }
  subject { post }

  it { should be_valid }

  describe "when name is not present" do
    before { post.name = " " }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { post.title = " " }
    it { should_not be_valid }
  end

  describe "when text is not present" do
    before { post.text = " " }
    it { should_not be_valid }
  end

  describe "when name is invalid" do
    it "should be invalid" do
      names = %w[tit-le Tit.le tit@le tit:le tit%le tit+le tit!le tit|le tit`le]
      names.each do |invalid_name|
        post.name = invalid_name
        expect(post).not_to be_valid
      end
    end
  end

  describe "when name is valid" do
    it "should be valid" do
      names = %w[title TITLE tit_le title0123 Название Название123]
      names.each do |valid_name|
        post.name = valid_name
        expect(post).to be_valid
      end
    end
  end

  describe "post url" do
    it "should be correct" do
      expect(post.post_url).to eq "/#{post.ancestry_path_params}"
    end
  end

  describe "child post url" do
    it "should be correct" do
      child = create(:post, name: 'child')
      post.add_child(child)
      expect(child.post_url).to eq "/#{post.ancestry_path_params}/child"
    end
  end
end