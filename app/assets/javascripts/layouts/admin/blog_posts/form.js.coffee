# app/assets/javascripts/layouts/admin/blog_posts/form.js.coffee

class Appleseed.Layouts.Admin.BlogPosts.Form extends Appleseed.Layouts.BaseLayout
  @selectors: {
    method_field:   '[name="_method"]'
    preview_button: '#preview-blog-post-button'
    slug_field:     '#blog_post_slug'
    title_field:    '#blog_post_title'
  }

  initialize: (root, options) ->
    super(root, options)

    # Auto-update the slug field as the title is changed.
    @get('title_field').bind 'keyup', @_updateSlugField

    # Show and bind events to preview button.
    @get('preview_button').show().bind 'click', @_openPreview

  parameterizeString = (string) ->
    string.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9\-]/g, '')

  _openPreview: (event) =>
    event.preventDefault()

    method_field = @get('method_field', false)
    form_action  = @$el.attr('action')
    form_method  = if 0 < method_field.length then method_field.val() else null

    # Modify the form to use the preview action.
    @$el.attr 'target', '_blank'
    @$el.attr 'action', @get('preview_button').data('path')
    method_field.val('') if 0 < method_field.length
    @$el.submit()

    # Reset the form to its prior configuration.
    @$el.removeAttr 'target'
    @$el.attr 'action', form_action
    method_field.val(form_method) if 0 < method_field.length

  _updateSlugField: (event) =>
    @get('slug_field').attr('placeholder', parameterizeString @get('title_field').val())
