require "test_helper"

<% module_namespacing do -%>
class <%= class_name %>HelperTest < ActionView::TestCase

  def test_sanity
    flunk "Need real tests"
  end

end
<% end -%>
