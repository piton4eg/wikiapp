require 'rails_helper'

describe PostsHelper do
  describe "formatter" do
    it "replace ** to bold" do
      expect(markdown("The **bold**")).to eq("<p>The <b>bold</b></p>\n")
    end

    it "replace \\ to italic" do
      expect(markdown("The \\\\italic\\\\")).to eq("<p>The <i>italic</i></p>\n")
    end

    it "replace ((url [title])) to link" do
      expect(markdown("The ((/link/url[title]))")).to eq("<p>The <a href='/link/url'>title</a></p>\n")
    end
  end
end