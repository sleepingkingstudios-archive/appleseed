# spec/javascripts/support/matchers/respond_to_matcher.js.coffee

#= require sleeping_king_studios/jasmine/matchers

SleepingKingStudios.Jasmine.Matchers.RespondToMatcher = (util, customEqualityTesters) ->
  { compare: (actual, expected) ->
    type = typeof actual[expected]
    if 'function' == typeof actual[expected]
      return {
        pass: true,
        message: "Expected #{actual} not to respond to #{expected}"
      } # end object
    else
      return {
        pass: false,
        message: "Expected #{actual} to respond to #{expected}, but was #{type}"
      } # end object
  } # end matcher

beforeEach ->
  jasmine.addMatchers {
    toRespondTo: SleepingKingStudios.Jasmine.Matchers.RespondToMatcher
  } # end matchers
