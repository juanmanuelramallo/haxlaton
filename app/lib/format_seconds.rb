class FormatSeconds
  def initialize(seconds)
    @seconds = seconds
  end

  def format
    "#{f(hours)}:#{f(minutes)}:#{f(seconds)}"
  end

  private

  def hours
    @seconds / 3600
  end

  def minutes
    (@seconds / 60) % 60
  end

  def seconds
    @seconds % 60
  end

  def f(num)
    num.to_s.rjust(2, "0")
  end
end
