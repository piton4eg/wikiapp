class Post < ActiveRecord::Base
  acts_as_tree

  validates :name, format: { with: /\A[a-zA-Z0-9_а-яА-Я]+\z/ }
  validates :title, :text, presence: true

  # URL для страницы
  def post_url(postfix = nil)
    url = "/#{ancestry_path_params}"
    url += "/#{postfix}" if postfix
    url
  end

  def ancestry_path_params
    ancestry_path.join('/')
  end
end
