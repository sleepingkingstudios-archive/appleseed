# app/assets/javascripts/views/base_view.js.coffee

class Appleseed.Views.BaseView extends Marionette.View
  initialize: (root, options = null) ->
    options = _.extend(options ?= {}, { el: root })

    super(options)

  selectors: ->
    # FIXME: This probably needs to be a deep merge operation.
    inherited = @_getSuperclassProperty 'selectors'
    _.extend(inherited ?= {}, @constructor.selectors)

  _getSuperclassProperty: (property) ->
    @constructor.__super__.constructor[property]
