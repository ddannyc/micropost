module ApplicationHelper
  include QiniuHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title='')
    base_title = "燕十三自说自话"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def format_date(d, time = false)
    strformat = "%Y-%m-%d"
    strformat = strformat + " %H:%M" if time
    d.strftime(strformat)
  end

  def to_md(text)
    html_render_options = {
      filter_html:     true, # no input tag or textarea
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow' }
    }

    markdown_options = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true
    }

    renderer = Redcarpet::Render::HTML.new(html_render_options)
    markdown = Redcarpet::Markdown.new(renderer, markdown_options)
    raw markdown.render(text)
  end
end
