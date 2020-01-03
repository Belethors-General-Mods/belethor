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

  @type valid_changes() :: %{
    optional(atom) => {atom(), (term() -> term())}
  }

  @type change() :: %{
    optional(atom) => term()
  }

  @doc """
  Clean changes from a maybe dirty map (with unexpected keys for example), to a sanitized.
  """
  @spec clean_changes(unclean :: Common.unclean_change(), vc:: valid_changes()) :: change()
  def clean_changes(unclean, vc) do
    unclean
    |> Map.to_list()
    |> List.foldl(%{},
    fn {attr, value}, acc ->
      case Map.get(vc, attr, :notfound) do
        :notfound -> acc
        {clean_attr, trans} ->
          clean_value = trans.(value)
          Map.put(acc, clean_attr, clean_value)
      end
    end)
  end

  @doc """
  this ensures you get a binary string back.
  only accepts binary inputs for now, duh.
  """
  @spec to_string(input :: binary()) :: binary()
  def to_string(input) when is_binary(input) do
    input
  end

  @spec to_bool(input :: binary()) :: bool()
  def to_bool(input) when is_binary(input) do
    case input do
      "true" -> true
      "false" -> false
    end
  end

end
