# spec/javascripts/appleseed/views/base_view_spec.js.coffee

describe 'Appleseed.Views.BaseView', ->
  describedClass = null
  instance       = null
  el             = null

  beforeEach ->
    describedClass = Appleseed.Views.BaseView
    el             = $('<div>')
    instance       = new describedClass el

  it 'exists', ->
    expect(describedClass).toBeDefined()

  describe '#selectors', ->
    it 'is a function', ->
      expect(instance).toRespondTo('selectors')

    describe 'with no selectors', ->
      it 'returns an empty hash', ->
        expect(instance.selectors()).toEqual({})

    describe 'with defined selectors', ->
      localSelectors = null

      beforeEach ->
        localSelectors = { foo: 'foo' }
        describedClass = describedClass.extend {}, {
          selectors: localSelectors
        }
        instance       = new describedClass el

      it 'returns the selectors hash', ->
        expect(instance.selectors()).toEqual(localSelectors)

    describe 'with a superclass and defined selectors', ->
      localSelectors = null
      superSelectors = null

      beforeEach ->
        superSelectors = { baz: 'baz', bar: 'cheers' }
        superClass     = describedClass.extend {}, {
          selectors: superSelectors
        }

        localSelectors = { foo: 'foo', bar: 'bar' }
        describedClass = superClass.extend {}, {
          selectors: localSelectors
        }
        instance       = new describedClass el

      it 'returns the merged selectors hashes', ->
        expect(instance.selectors()).toEqual(_.extend(superSelectors, localSelectors))
