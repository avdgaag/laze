require 'bluecloth'

Laze::Plugin.define 'markdown' do
  author      'Arjan van der Gaag'
  version     '1.0'
  description 'Write pages in Markdown.'
  priority    9

  MARKDOWN_EXTENSIONS = %w{.md .markdown .mdn}

  def filter_page_filename(page)
    if_markdown(page) do |extension, p|
      p.properties[:output_filename] = p.properties[:filename].gsub(extension, '.html')
    end
  end

  def generate_page_content(page)
    if_markdown(page) do |extension, p|
      p.content = BlueCloth.new(p.content).to_html
    end
  end

  def if_markdown(page)
    extension = File.extname(page.properties[:filename])
    if MARKDOWN_EXTENSIONS.include?(extension)
      yield extension, page
    end
    page
  end
end