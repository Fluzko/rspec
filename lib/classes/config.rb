class Config
  attr_reader :string_proc

  def initialize(proc, string_proc)
    @proc = proc
    @string_proc = string_proc
  end

  def call(an_obj)
    @proc.call(an_obj)
  end
end