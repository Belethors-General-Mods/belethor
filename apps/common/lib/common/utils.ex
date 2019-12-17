defmodule Common.Utils do
  @moduledoc "Module for utilities used across belethor."

  @doc """
  Macro to correctly log debug messages.

  Calls `Logger.debug` in a way that makes dialyzer happy and does impact performance in production.
  """
  defmacro debug(msg) do
    quote do
      :ok = Logger.debug(fn -> unquote(msg) end)
    end
  end

  @spec to_bool(input :: binary()) :: bool()
  def to_bool(input) do
    case input do
      "true" -> true
      "false" -> false
    end
  end

end
