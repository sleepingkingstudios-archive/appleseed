# spec/javascripts/support/matchers/match_elements_with_matcher.js.coffee

#= require sleeping_king_studios/jasmine/matchers

SleepingKingStudios.Jasmine.Matchers.MatchElementsWithMatcher = (util, customEqualityTesters) ->
  { compare: ($actual, $expected) ->
    return {
      pass: false,
      message: "Expected actual to be a JQuery array, but was #{$actual}."
    } unless $actual instanceof $

    return {
      pass: false,
      message: "Expected value to be a JQuery array, but was #{expected}."
    } unless $expected instanceof $

    return {
      pass: false,
      message: "Expected #{$actual} to have #{$expected.length} elements, but has #{$actual.length} elements."
    } unless $actual.length == $expected.length

    for element, index in $expected
      return {
        pass: false,
        message: "Expected #{$actual}[#{index}] to match #{element}, but was #{$actual[index]}"
      } unless element == $actual[index]

    return {
      pass: true
      message: "Expected elements of #{$actual} not to match elements of #{$expected}."
    }
  } # end matcher

beforeEach ->
  jasmine.addMatchers {
    toMatchElementsWith: SleepingKingStudios.Jasmine.Matchers.MatchElementsWithMatcher
  } # end matchers
