# Require core libraries.
#= require jquery
#= require jquery_ujs
#= require jquery.autosize.min
#= require underscore

# Require responsive framework files.
#= require foundation

# Require JavaScript framework files.
#= require backbone
#= require backbone.marionette

#= require appleseed
#= require_tree .

$ ->
  # Start the Marionette application.
  Appleseed.application.start()

  # Run responsive framework scripts.
  $(document).foundation()
