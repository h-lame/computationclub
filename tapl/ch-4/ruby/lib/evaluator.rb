require 'rules'
require 'term'

def evaluate(term)
  loop do
    term_prime = Evaluator.evaluate!(term)
    term = term_prime
  end
rescue Evaluator::NoRulesApply
  term
end

class Evaluator
  class NoRulesApply < StandardError; end

  def self.evaluate!(term)
    new(term).evaluate!
  end

  attr_reader :term
  def initialize(term)
    @term = term
  end

  def evaluate!
    rule_to_apply = find_matching_rule
    if rule_to_apply
      rule_to_apply.apply(term)
    else
      raise NoRulesApply
    end
  end

  private

  def find_matching_rule
    rules_to_try.detect { |rule| rule.matches?(term) }
  end

  def rules_to_try
    self.class.rules_to_try
  end

  def self.rules_to_try
    @_rules_to_try ||=
      [
        Rules.e_ifTrue,
        Rules.e_ifFalse,
        Rules.e_if,
        Rules.e_succ,
        Rules.e_predZero,
        Rules.e_predSucc,
        Rules.e_pred,
        Rules.e_isZeroZero,
        Rules.e_isZeroSucc,
        Rules.e_isZero,
      ].freeze
  end
end

Rules.evaluator = Evaluator
