# app/views/admin/blog_posts/_post.json.jbuilder

json.author do
  json.partial! 'admin/blog_posts/post/author', :author => blog_post.author
end # author

json.blog do
  json.partial! 'admin/blog_posts/post/blog', :blog => blog_post.blog
end # blog

json.title        blog_post.title
json.content      blog_post.content
json.content_type blog_post.content_type

if blog_post.published?
  json.published_at blog_post.published_at.utc.iso8601
else
  json.published_at 'null'
end # if-else
