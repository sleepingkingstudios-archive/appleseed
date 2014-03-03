# app/assets/javascripts/layouts/admin/blog_posts/show.js.coffee

class Appleseed.Layouts.Admin.BlogPosts.Show extends Appleseed.Layouts.BaseLayout
  @selectors: {
    delete_link: '.delete-link'
    modal:
      sel:    '#confirm-delete-modal'
      action: '.confirm-delete-button'
      cancel: '#cancel-delete-button'
      close:  '.close-reveal-modal'
  }

  initialize: (root, options) ->
    super(root, options)

    @_mockDeleteLink()
    @_bindModalActions()

  _bindModalActions: () =>
    $close = @get('modal.close')
    @get('modal.cancel').bind 'click', => $close.click()
    @get('modal.action').bind 'click', => @get('delete_link').click()

  _mockDeleteLink: () =>
    $mock = @get('delete_link').clone()
    $mock.removeAttr('id').removeAttr('data-method')
    $mock.attr('href', '#')
    $mock.attr('data-reveal-id', 'confirm-delete-modal')

    @get('delete_link').after($mock).hide()
