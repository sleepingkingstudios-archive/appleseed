# app/assets/javascripts/views/admin/blogs/show.js.coffee

class Appleseed.Views.Admin.Blogs.Show extends Appleseed.Views.BaseView
  @selectors: {
    delete_button:  '.delete-button',
    modal:
      sel: '#confirm-delete-modal',
      action: '.confirm-delete-button'
  }

  initialize: (root, options) ->
    super(root, options)

    # Define selectors.
    @$orig  = $ '.delete-button'
    @$modal = $ '#confirm-delete-modal'
    
    @mockDeleteButton()
    @bindModalAction()

  bindModalAction: () ->
    @$action = @$modal.find('.confirm-delete-button')
    @$action.bind 'click', => @$orig.click()

  mockDeleteButton: () ->
    @$mock = @$orig.clone()
    @$mock.removeAttr('id').removeAttr('data-method')
    @$mock.attr('href', '#')
    @$mock.attr('data-reveal-id', 'confirm-delete-modal')

    @$orig.after(@$mock)
    @$orig.hide()
