# app/assets/javascripts/admin/blog_posts.js.coffee 

# Replace these with proper views once your framework is set up.

# Admin::BlogPosts#show
$ ->
  $root = $('body.admin-blog-posts-show')
  return unless $root?

  # Set up the Confirm Delete Blog modal.
  $modal = $root.find('#confirm-delete-modal')

  $delete_button  = $root.find('#delete-blog-post-link')
  $hidden_button  = $root.find('#open-confirm-delete-modal-link')
  $confirm_button = $modal.find('#confirm-delete-link')
  $cancel_button  = $modal.find('#cancel-delete-link')

  # Hide the actual button and show the modal popup button.
  $delete_button.hide()
  $hidden_button.show()

  $cancel_button.click (event) -> $modal.foundation 'reveal', 'close'
  $confirm_button.click (event) -> $delete_button.click()

# Admin::Blogs#new
$ ->
  $root = $('body.admin-blog-posts-new')
  return unless $root?

  # Enable autosize for the content field.
  $root.find('#blog_post_content').autosize()

# Admin::Blogs#edit
$ ->
  $root = $('body.admin-blog-posts-edit')
  return unless $root?

  # Enable autosize for the content field.
  $root.find('#blog_post_content').autosize()
