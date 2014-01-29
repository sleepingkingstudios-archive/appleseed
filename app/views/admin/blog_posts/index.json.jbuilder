if @blog
  json.array!(@blog_posts) do |blog_post|
    json.partial! 'post', :blog_post => blog_post
  end # array
else
  json.null!
end # if-else
