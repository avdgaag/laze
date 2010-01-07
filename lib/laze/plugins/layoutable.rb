# Laze::Plugin.define 'layoutable' do
#   author      'Arjan van der Gaag'
#   version     '1.0'
#   description 'Wrap pages in (nested) layouts.'
#   builtin     true
#
#   def generate_page_content(page)
#     if page.has?(:layout)
#       page.content = wrap_in_layout(page.properties[:layout], page.content).content
#     end
#     page
#   end
#
#   def filter_layout(layout_with_metadata)
#     if layout_with_metadata.has?(:layout)
#       wrap_in_layout(layout_with_metadata.properties[:layout], layout_with_metadata.content)
#     else
#       layout_with_metadata
#     end
#   end
#
#   def wrap_in_layout(layout_name, content)
#     layout = Laze::Store[Laze::Secretary.options[:store]].layout(layout_name)
#     layout.content.gsub!(/\{\{\s*yield\s*\}\}/, content)
#     layout
#   end
# end