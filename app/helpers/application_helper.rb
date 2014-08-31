module ApplicationHelper
  def octicon(code, attributes = {})
    content_tag :span, '', {:class => "octicon octicon-#{code.to_s.dasherize}"}.merge(attributes)
  end
end
