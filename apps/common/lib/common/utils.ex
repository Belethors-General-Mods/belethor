defmodule Common.Utils do
  @moduledoc "Module for utilities used across belethor."

  require Logger

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
  @spec clean_changes(unclean :: Common.unclean_change(), vc :: valid_changes()) :: change()
  def clean_changes(unclean, vc) do
    unclean
    |> Map.to_list()
    |> List.foldl(
      %{},
      fn {attr, value}, acc ->
        case Map.get(vc, attr, :notfound) do
          :notfound ->
            debug("cleaning changes: key '#{attr}' not found (and thus ignored)")
            acc

          {clean_attr, trans} ->
            try do
              clean_value = trans.(value)
              Map.put(acc, clean_attr, clean_value)
            rescue
              x ->
                debug("Errors during cleaning changes: #{inspect(x)}")
                acc
            end
        end
      end
    )
  end

  @doc """
  this ensures you get a binary string back.
  only accepts binary inputs for now, duh.
  """
  @spec to_string(input :: binary() | nil) :: binary()
  def to_string(nil), do: ""

  def to_string(input) when is_binary(input) do
    input
  end

  @spec to_bool(input :: binary() | bool()) :: bool()
  def to_bool(input) when is_boolean(input), do: input

  def to_bool(input) when is_binary(input) do
    case input do
      "true" -> true
      "false" -> false
    end
  end
end
