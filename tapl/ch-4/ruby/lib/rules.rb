class Rules
  def self.evaluator=(evaluator)
    @evaluator = evaluator
  end

  def self.evaluate!(term)
    @evaluator.evaluate!(term)
  end

  class Rule
    def initialize(matcher, applicator)
      @matcher = matcher
      @applicator = applicator
    end

    def matches?(term)
      @matcher.call(term)
    end

    def apply(term)
      @applicator.call(term)
    end
  end

  def self.e_ifTrue
    Rule.new(
      ->(term) { term.is_a?(If) && term.conditional.is_a?(True) },
      ->(term) { term.when_true }
    )
  end

  def self.e_ifFalse
    Rule.new(
      ->(term) { term.is_a?(If) && term.conditional.is_a?(False) },
      ->(term) { term.when_false }
    )
  end

  def self.e_if
    Rule.new(
      ->(term) { term.is_a?(If) && evaluate!(term.conditional) },
      ->(term) { If.new(evaluate!(term.conditional), term.when_true, term.when_false) }
    )
  end

  def self.e_succ
    Rule.new(
      ->(term) { term.is_a?(Succ) && evaluate!(term.arg) },
      ->(term) { Succ.new(evaluate!(term.arg)) }
    )
  end

  def self.e_predZero
    Rule.new(
      ->(term) { term.is_a?(Pred) && term.arg.is_a?(Zero) },
      ->(term) { term.arg }
    )
  end

  def self.e_predSucc
    Rule.new(
      ->(term) { term.is_a?(Pred) && term.arg.is_a?(Succ) && term.arg.arg.isNumericVal? },
      ->(term) { term.arg.arg }
    )
  end

  def self.e_pred
    Rule.new(
      ->(term) { term.is_a?(Pred) && evaluate!(term.arg) },
      ->(term) { Pred.new(evaluate!(term.arg)) }
    )
  end

  def self.e_isZeroZero
    Rule.new(
      ->(term) { term.is_a?(IsZero) && term.arg.is_a?(Zero) },
      ->(term) { True.new }
    )
  end

  def self.e_isZeroSucc
    Rule.new(
      ->(term) { term.is_a?(IsZero) && term.arg.is_a?(Succ) && term.arg.arg.is_numericVal? },
      ->(term) { False.new }
    )
  end

  def self.e_isZero
    Rule.new(
      ->(term) { term.is_a?(IsZero) && evaluate!(term.arg) },
      ->(term) { IsZero.new(evaluate!(term.arg)) }
    )
  end
end
