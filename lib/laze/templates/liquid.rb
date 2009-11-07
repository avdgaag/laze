Laze::Template.define :liquid do
  def render
    Liquid::Template.parse(@page.wrapped_in_layout).render('page' => @page)
  end
end

module Laze
  class Item
    def to_liquid
      properties.merge({ 'content' => content })
    end
  end
end