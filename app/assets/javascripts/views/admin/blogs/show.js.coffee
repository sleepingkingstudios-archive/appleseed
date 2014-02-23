# app/assets/javascripts/views/admin/blogs/show.js.coffee

class Appleseed.Views.Admin.Blogs.Show extends Marionette.View
  initialize: (options) ->
    # Define selectors.
    @$orig  = $ '.delete-button'
    @$modal = $ '#confirm-delete-modal'
    
    @mockDeleteButton()
    @bindModalAction()

  bindModalAction: () ->
    @$action = @$modal.find('.confirm-delete-button')
    console.log @$action
    @$action.bind 'click', => @$orig.click()

  mockDeleteButton: () ->
    @$mock = @$orig.clone()
    @$mock.removeAttr('id').removeAttr('data-method')
    @$mock.attr('href', '#')
    @$mock.attr('data-reveal-id', 'confirm-delete-modal')

    @$orig.after(@$mock)
    @$orig.hide()
