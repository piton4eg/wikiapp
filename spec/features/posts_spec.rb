require 'rails_helper'

describe 'Posts' do
  let!(:grand)  { create(:post, name: 'Grand') }
  let!(:parent) { grand.add_child(create(:post, name: 'Parent')) }
  let!(:child)  { parent.add_child(create(:post, name: 'Child')) }

  describe 'Root page' do
    it "should have tree and link for creating root post" do
      visit root_path
      expect(page).to have_content "Добавить корневую страницу"
      expect(page).to have_content "Список страниц"
      
      expect(page).to have_content grand.name
      expect(page).to have_content parent.name
      expect(page).to have_content child.name
    end
  end  

  describe 'Grand page' do
    it "should have subtree and links" do
      visit grand.post_url
      expect(page).to have_content "Создать подстраницу"
      expect(page).to have_content "Редактировать"

      expect(page).to have_content grand.name
      expect(page).to have_content parent.name
      expect(page).to have_content child.name
    end
  end

  describe 'Parent page' do
    it "should not have link to grand post" do
      visit parent.post_url

      expect(page).not_to have_content grand.name
      expect(page).to have_content parent.name
      expect(page).to have_content child.name      
    end
  end

  describe 'Child page' do
    it "should not have link to grand and parent posts" do
      visit child.post_url

      expect(page).not_to have_content grand.name
      expect(page).not_to have_content parent.name
      expect(page).to have_content child.name      
    end
  end
end
