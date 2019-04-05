# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create({login: 'jsmith', name: 'John Smith', provider: 'github'})

Article.create!([
    {title: "Article 1", content: "content article 1", slug: "article-1", user: user},
    {title: "Article 2", content: "content article 2", slug: "article-2", user: user},
    {title: "Article 3", content: "content article 3", slug: "article-3", user: user}
])