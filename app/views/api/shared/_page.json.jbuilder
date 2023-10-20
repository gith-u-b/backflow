if items.present?
  if defined?(items.current_page)
    json.current_page items.current_page
    json.total_pages items.total_pages
    json.total_count items.total_count
  elsif items.is_a?(Array)
    json.current_page 1
    json.total_pages 1
    json.total_count items.count
  end
else
  json.current_page 1
  json.total_pages 1
  json.total_count 0
end
