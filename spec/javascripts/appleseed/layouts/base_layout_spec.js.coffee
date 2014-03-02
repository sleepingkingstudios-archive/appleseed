# spec/javascripts/appleseed/layouts/base_layout_spec.js.coffee

describe 'Appleseed.Layouts.BaseLayout', ->
  describedClass = null
  instance       = null
  $el            = null

  beforeEach ->
    describedClass = Appleseed.Layouts.BaseLayout
    $el            = $('<div>')
    instance       = new describedClass { el: $el }

  it 'exists', ->
    expect(describedClass).toBeDefined()

  describe '#get', ->
    it 'is a function', ->
      expect(instance).toRespondTo('get')

    describe 'with an undefined selector', ->
      it 'throws an error', ->
        expect(-> instance.get 'xyzzy').toThrow('Undefined selector "xyzzy"')

  describe '#selectors', ->
    it 'is a function', ->
      expect(instance).toRespondTo('selectors')

    it 'returns an empty hash', ->
      expect(instance.selectors()).toEqual({})

  describe 'with defined selectors', ->
    localSelectors = null

    beforeEach ->
      localSelectors = { foo: '.foo' }
      describedClass = describedClass.extend {}, {
        selectors: localSelectors
      }
      instance       = new describedClass { el: $el }

    describe '#selectors', ->
      it 'returns the selectors hash', ->
        expect(instance.selectors()).toEqual(localSelectors)

  describe 'with a superclass and defined selectors', ->
    localSelectors = null
    superSelectors = null

    beforeEach ->
      superSelectors = { baz: 'baz', bar: ':cheers', dilly: { sel: '.pickle-y', wibble: '.wobble' } }
      superClass     = describedClass.extend {}, {
        selectors: superSelectors
      }

      localSelectors = { foo: '.foo', bar: '#bar', dilly: { sel: '#dally' } }
      describedClass = superClass.extend {}, {
        selectors: localSelectors
      }
      instance       = new describedClass { el: $el }

    describe '#get', ->
      describe 'with an undefined selector', ->
        it 'throws an error', ->
          expect(-> instance.get 'xyzzy').toThrow('Undefined selector "xyzzy"')

      describe 'with a missing element', ->
        it 'throws an error', ->
          expect(-> instance.get 'foo').toThrow('No element found for selector "foo" (\'.foo\')')

      describe 'with an existing element', ->
        $child = null

        beforeEach ->
          $child = $ '<span id="bar">'
          $el.append($child)
          instance = new describedClass { el: $el }

        it 'returns the element', ->
          expect(instance.get 'bar').toMatchElementsWith($child)

      describe 'with a nested selector', ->
        $child      = null
        $grandchild = null

        beforeEach ->
          $child = $ '<div id="dally">'
          $grandchild = $ '<span class="wobble">'
          $el.append($child)
          $child.append($grandchild)
          instance = new describedClass { el: $el }

        it 'returns the element', ->
          expect(instance.get 'dilly.wibble').toMatchElementsWith($grandchild)

    describe '#selectors', ->
      expected = null

      beforeEach ->
        expected = {
          foo: '.foo',
          bar: '#bar',
          baz: 'baz',
          'dilly.wibble': '#dally .wobble'
        }

      it 'returns the merged and flattened selectors hashes', ->
        for key, value in expected
          expect(instance.selectors()[key]).toEqual(value)
