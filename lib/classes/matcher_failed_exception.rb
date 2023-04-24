class MatcherFailedException < StandardError
  def initialize(string_operation, excecuted_at)
    reason = string_operation.to_s.sub '{x}', excecuted_at.to_s
    super(reason)
  end
end
