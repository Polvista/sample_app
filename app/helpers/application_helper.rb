module ApplicationHelper
  def title
    base_title = "No title"
    if @title.nil?
      base_title
    else
      @title
    end
  end
end
