class Complicated
  attr_reader :real, :imaginary
  def initialize(real, imaginary = 0)
    raise ArgumentError, "real part must be a number" unless real.is_a? Numeric
    raise ArgumentError, "imaginary part must be a number" unless imaginary.is_a? Numeric
    @real = real
    @imaginary = imaginary
  end

  def to_s
    "(#{real}, #{imaginary}i)"
  end

  def +(other)
    case other
    when Complicated
      Complicated.new(self.real + other.real, self.imaginary + other.imaginary)
    when Numeric
      self + Complicated.new(other)
    else
      raise ArgumentError, "Can't add #{other.class} to #{self.class}"
    end
  end

  def *(other)
    case other
    when Complicated
      Complicated.new((self.real * other.real) - (self.imaginary * other.imaginary), (self.real * other.imaginary) + (self.imaginary * other.real))
    when Numeric
      self * Complicated.new(other)
    else
      raise ArgumentError, "Can't multiply #{self.class} by #{other.class}"
    end
  end

  def **(other)
    raise ArgumentError, "Don\'t know how to raise #{self.class} to a power of #{other.class}" unless other.is_a? Numeric
    return Complicated.new(1) if other == 0
    return self if other == 1
    (other - 1).times.inject(self) { |x, _| x * self }
  end

  def abs
    Math.sqrt(real**2 + imaginary**2)
  end
end
