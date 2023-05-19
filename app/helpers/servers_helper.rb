module ServersHelper
  def badge_for_server_status(server)
    status_class_mapping = {
      "Starting" => "badge-soft-info",
      "Online" => "badge-soft-success",
      "Offline" => "badge-soft-warning",
    }
    content_tag :span, server.status, class: "badge badge-pill #{status_class_mapping.fetch(server.status, "badge-soft-dark")}"
  end
end
