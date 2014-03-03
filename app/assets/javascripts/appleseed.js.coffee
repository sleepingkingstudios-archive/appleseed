# app/assets/javascripts/appleseed.js.coffee

# Define top-level constant, namespaces and helpers.
@Appleseed = {
  Layouts:
    Admin:
      Blogs: {}
      BlogPosts: {}

  resolveNamespace: (string) ->
    module = Appleseed
    module = module[segment] for segment in string.split('.')
    module
}

# Create application.
Appleseed.application = new Backbone.Marionette.Application()

# Add initializers.
Appleseed.application.addInitializer (options) ->
  # Find all elements with declared layouts and create the corresponding
  # Marionette layouts.
  for el in $ '[data-appleseed-layout]'
    layoutName  = ($el = $ el).data('appleseedLayout')
    layoutClass = Appleseed.resolveNamespace("Layouts.#{layoutName}")
    layout      = new layoutClass { el: $el }

  # Apply form and other element-specific JS enhancements.
  $(el).autosize() for el in $ 'textarea[data-appleseed-autosize="true"]'
