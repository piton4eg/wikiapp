# Вставка курсива и ссылок
class MyOwnFormatter < Redcarpet::Render::HTML
  def preprocess(text)
    text = text.gsub(/\\\\(.*)\\\\/) { "<i>#{$1}</i>" }
    text = text.gsub(/\(\((.*)\[(.*)\]\)\)/) { "<a href='#{$1}'>#{$2}</a>" }
    text.gsub(/\*\*(.*)\*\*/) { "<b>#{$1}</b>" }
  end
end

module PostsHelper
  # Построение дерева
  def posts_tree_for(posts)
    posts.map do |post, nested_posts|
      render(post) +
        (nested_posts.size > 0 ? content_tag(:div, posts_tree_for(nested_posts), class: "children") : nil)
    end.join.html_safe
  end

  # Обработка текста при просмотре
  def markdown(text)
    renderer = MyOwnFormatter.new(hard_wrap: true)
    Redcarpet::Markdown.new(renderer).render(text).html_safe
  end
end
