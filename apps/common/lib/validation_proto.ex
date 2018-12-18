defprotocol Common.Validation do
  @doc "check wether data (like `Common.Image`) has valid attribute values."
  @spec valid?(any()) :: boolean()
  def valid?(data)
end
