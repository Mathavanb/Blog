json.array! @categories do |categories|
  json.name categories.name
  json.description categories.description
  json.url category_url(categories)
end