defmodule Common.Struct do
  @moduledoc """
  common behaviour for structs used in common.
  """

  @type reason :: any()

  @doc "validates a struct instance of the implementing module"
  @callback validate(struct()) :: :ok | {:error, reason()}
end
