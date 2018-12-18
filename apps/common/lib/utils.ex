defmodule Common.Utils do
  @moduledoc "Module for utilities used across belethor."

  @doc """
  macro to correctly log debug messages.

  Calls `Logger.debug` in a way that makes dialyzer happy and does impact performance in production.
  """
  defmacro debug(msg) do
    quote do
      :ok = Logger.debug(fn -> unquote(msg) end)
    end
  end
end
