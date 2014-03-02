# spec/javascripts/matchers/respond_to_matcher_spec.js.coffee

describe 'SleepingKingStudios.Jasmine.Matchers.MatchElementsWithMatcher', ->
  $actual   = null
  $expected = null

  beforeEach ->
    $actual   = $('<div>')
    $expected = $($actual[0])

  it 'exists', ->
    expect(SleepingKingStudios.Jasmine.Matchers.MatchElementsWithMatcher).toBeDefined()

  it 'is available on an expectation', ->
    expect($actual).toMatchElementsWith($expected)

  describe 'with null actual', ->
    beforeEach ->
      $actual = null

    it 'returns false', ->
      expect($actual).not.toMatchElementsWith($expected)

  describe 'with null expected', ->
    beforeEach ->
      $actual = null

    it 'returns false', ->
      expect($actual).not.toMatchElementsWith($expected)

  describe 'with mismatched element counts', ->
    beforeEach ->
      $builder = $('<div>').append('<span>').append('<span>').append('<span>')
      $actual  = $builder.children

    it 'returns false', ->
      expect($actual).not.toMatchElementsWith($expected)

  describe 'with mismatched elements', ->
    beforeEach ->
      $expected = $('<span>')

    it 'returns false', ->
      expect($actual).not.toMatchElementsWith($expected)

  describe 'with matching elements', ->
    beforeEach ->
      $builder = $('<div>').
        append('<span class="element">').
        append('<span class="element">').
        append('<span class="element">')
      $actual   = $builder.find('span')
      $expected = $builder.find('.element')

    it 'returns true', ->
      expect($actual).toMatchElementsWith($expected)
