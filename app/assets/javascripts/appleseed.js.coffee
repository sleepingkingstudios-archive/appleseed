# app/assets/javascripts/appleseed.js.coffee

# Define top-level constant, namespaces and helpers.
@Appleseed = {
  Views:
    Admin:
      Blogs: {}

  resolveNamespace: (string) ->
    module = Appleseed
    module = module[segment] for segment in string.split('.')
    module
}

# Create application.
Appleseed.application = new Backbone.Marionette.Application()

# Add initializers.
Appleseed.application.addInitializer (options) ->
  # Find all elements with declared views and create the corresponding
  # Marionette views.
  for el in $ '[data-appleseed-view]'
    viewName  = $(el).data('appleseedView')
    viewClass = Appleseed.resolveNamespace("Views.#{viewName}")
    view      = new viewClass { el: el }
