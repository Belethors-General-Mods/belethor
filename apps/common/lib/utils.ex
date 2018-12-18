defmodule Common.Utils do

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
