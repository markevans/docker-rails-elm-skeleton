module ApplicationHelper

  def js_pack_tag_same_host(name)
    # Using the same host makes it easier to work with Docker
    javascript_pack_tag(name).sub(/\d+\.\d+\.\d+\.\d+/, request.host).html_safe
  end

end
