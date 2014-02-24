# spec/javascripts/appleseed_spec.js.coffee

describe 'Appleseed', ->
  it 'exists', ->
    expect(Appleseed).toBeDefined()

  describe '#resolveNamespace', ->
    it 'is a function', ->
      expect(Appleseed).toRespondTo('resolveNamespace')

    describe 'with a defined namespace', ->
      namespace = null
      module    = null

      beforeEach ->
        Appleseed.Foo = {
          Bar:
            Baz: {}
        }

        namespace = "Foo.Bar.Baz"
        module    = Appleseed.Foo.Bar.Baz

      afterEach ->
        delete Appleseed.Foo

      it 'returns the specified module', ->
        expect(Appleseed.resolveNamespace namespace).toBe(module)
