module WelcomeHelper

  def previous_page_link
    disabled = (@current_page == 1)
    html = "<li"
    html += " class='disabled'" if disabled
    html += ">"
    unless disabled
      html += "<a href='?page=#{@current_page - 1}' class='js-page-link' "
      html += "data-page='#{@current_page - 1}' aria-label='Previous Page'>"
    end
    html += "« <span class='show-for-sr'>Previous page</span>"
    html += "</a>" unless disabled
    html += "</li>"
    html
  end

  def next_page_link
    disabled = (@current_page >= @num_pages)
    html = "<li"
    html += " class='disabled'" if disabled
    html += ">"
    unless disabled
      html += "<a href='?page=#{@current_page + 1}' class='js-page-link' "
      html += "data-page='#{@current_page + 1}' aria-label='Next page'>"
    end
    html += "» <span class='show-for-sr'>Next page</span>"
    html += "</a>" unless disabled
    html += "</li>"
    html
  end

  def generic_page_link(number)
    disabled = (number == @current_page)
    html = "<li"
    html += " class='disabled'" if disabled
    html += ">"
    unless disabled
      html += "<a href='?page=#{number}' class='js-page-link'"
      html += " data-page='#{number}' aria-label='Page #{number}'>"
    end
    html += "#{number}"
    html += "</a>" unless disabled
    html += "</li>"
    html
  end

end
