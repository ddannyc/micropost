module ApplicationHelper
  include QiniuHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title='')
    base_title = "燕十三的唠叨"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def format_time(d)
    d.strftime("%Y-%m-%d %H:%M:%S")
  end
end
