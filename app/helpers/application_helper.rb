module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def admin
    signed_in? && current_user.has_role?(:admin)
  end

  def cool_date(date)
    date.strftime('%A, %B %d at %l:%M%p')
  end

  def emph(text)
    "<span style=\"font-weight:bold;\">#{text}</span>"
  end

end
