# app/assets/javascripts/admin/blogs.js.coffee

# Replace these with proper views once your framework is set up.

# Admin::Blogs#show
$ ->
  $root = $('body.admin-blogs-show')
  return unless $root?

  # Set up the Confirm Delete Blog modal.
  $modal = $root.find('#confirm-delete-modal')

  $delete_button  = $root.find('#delete-blog-link')
  $hidden_button  = $root.find('#open-confirm-delete-modal-link')
  $confirm_button = $modal.find('#confirm-delete-blog-link')
  $cancel_button  = $modal.find('#cancel-delete-blog-link')

  # Hide the actual button and show the modal popup button.
  $delete_button.hide()
  $hidden_button.show()

  $cancel_button.click (event) -> $modal.foundation 'reveal', 'close'
  $confirm_button.click (event) -> $delete_button.click()
