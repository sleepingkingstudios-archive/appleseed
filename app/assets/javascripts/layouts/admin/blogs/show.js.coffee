# app/assets/javascripts/layouts/admin/blogs/show.js.coffee

class Appleseed.Layouts.Admin.Blogs.Show extends Appleseed.Layouts.BaseLayout
  @selectors: {
    delete_button: '.delete-button'
    modal:
      sel:    '#confirm-delete-modal'
      action: '.confirm-delete-button'
      cancel: '#cancel-delete-button'
      close:  '.close-reveal-modal'
  }

  initialize: (root, options) ->
    super(root, options)
    
    @_mockDeleteButton()
    @_bindModalActions()

  _bindModalActions: () =>
    $close = @get('modal.close')
    @get('modal.cancel').bind 'click', => $close.click()
    @get('modal.action').bind 'click', => @get('delete_button').click()

  _mockDeleteButton: () =>
    $mock = @get('delete_button').clone()
    $mock.removeAttr('id').removeAttr('data-method')
    $mock.attr('href', '#')
    $mock.attr('data-reveal-id', 'confirm-delete-modal')

    @get('delete_button').after($mock).hide()
