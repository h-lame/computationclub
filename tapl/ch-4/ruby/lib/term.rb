class Term
  def inspect
    to_s
  end

  def to_s
    "#{self.class.name}"
  end

  def isVal?
    isNumericVal?
  end

  def isNumericVal?
    false
  end
end

class True < Term
  def isVal?
    true
  end
end

class False < Term
  def isVal?
    true
  end
end

class If < Term
  attr_reader :conditional, :when_true, :when_false
  def initialize(conditional, when_true, when_false)
    @conditional = conditional
    @when_true = when_true
    @when_false = when_false
  end

  def to_s
    "#{super}(#{conditional.to_s}) { #{when_true} } else { #{when_false} }"
  end
end

class Zero < Term
  def isNumericVal?
    true
  end
end

class Succ < Term
  attr_reader :arg

  def initialize(arg)
    @arg = arg
  end

  def to_s
    "#{super}(#{arg})"
  end

  def isNumericVal?
    arg.isNumericVal?
  end
end

class Pred < Term
  attr_reader :arg

  def initialize(arg)
    @arg = arg
  end

  def to_s
    "#{super}(#{arg})"
  end
end

class IsZero < Term
  attr_reader :arg

  def initialize(arg)
    @arg = arg
  end

  def to_s
    "#{super}(#{arg})"
  end
end
