# app/assets/javascripts/admin/blog_posts.js.coffee 

# Replace these with proper views once your framework is set up.

# Admin::BlogPosts#show
$ ->
  $root = $('body.admin-blog-posts-show')
  return unless $root.length > 0

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

# Admin::BlogPosts#new
$ ->
  $root = $('body.admin-blog-posts-new')
  return unless $root.length > 0

  # Enable autosize for the content field.
  $root.find('#blog_post_content').autosize()

# Admin::BlogPosts#edit
$ ->
  $root = $('body.admin-blog-posts-edit')
  return unless $root.length > 0

  # Enable autosize for the content field.
  $root.find('#blog_post_content').autosize()

# Admin::BlogPosts#_form
$ ->
  $root = $('.admin-blog-posts-form')
  return unless $root.length > 0

  $preview_button = $root.find('#preview-blog-post-link')
  $preview_button.show()
  $preview_button.click (event) ->
    event.preventDefault()

    $method_field = $root.find('[name="_method"]')

    form_action = $root.attr('action')
    form_method = $method_field.val()

    # Modify the form to use the preview action.
    $root.attr('target', '_blank')
    $root.attr('action', $preview_button.data('path'))
    $method_field.val('')
    $root.submit()

    # Reset the form to its prior configuration.
    $root.removeAttr('target')
    $root.attr('action', form_action)
    $method_field.val(form_method)

  parameterizeString = (string) ->
    string.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9\-]/g, '')

  # Auto-update the slug field as the title is changed.
  $title_field = $root.find('#blog_post_title')
  $slug_field  = $root.find('#blog_post_slug')
  $title_field.bind 'keyup', ->
    $slug_field.attr('placeholder', parameterizeString $title_field.val())

# Admin::BlogPosts#import
$ ->
  $root = $('.admin-blog-posts-import')
  return unless $root.length > 0

  # Enable autosize for the import field.
  $root.find('#blog_posts_data').autosize()
