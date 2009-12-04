Laze::Plugin.define 'includes' do
  author      'Arjan van der Gaag'
  version     '0.0.1'
  description 'Include one file in another.'

  def generate_page_content(page)
    page.content.gsub!(/\{%\s*include\s*(.+?)\s*%\}/) do |match|
      filename = File.join('includes', $1)
      IO.read(filename) or raise "Could not include #{filename}"
    end
    page
  end
end