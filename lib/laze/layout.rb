class Layout

  include Laze::Layoutable

  attr_accessor :content

  def initialize(content, layout = nil)
    @content, @layout = content, layout
  end
end