# app/assets/javascripts/admin/blog_posts.js.coffee 

# Replace these with proper views once your framework is set up.

# Admin::Blogs#new
$ ->
  $root = $('body.admin-blog-posts-new')
  return unless $root?

  # Enable autosize for the content field.
  $root.find('#blog_post_content').autosize()
