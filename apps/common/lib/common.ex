defmodule Common do
  @moduledoc """
  Documentation for Common.
  """

  @type unclean_change :: %{
    optional(binary) => binary() | unclean_change()
  }

end
