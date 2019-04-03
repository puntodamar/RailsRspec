json.articles articles do |article|
    json.id         article.id
    json.title      article.title
    json.content    article.content
    json.slug       article.slug
end