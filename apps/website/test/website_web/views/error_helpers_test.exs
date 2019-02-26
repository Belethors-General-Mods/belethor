defmodule WebsiteWeb.ErrorHelpersTest do
  @moduledoc false
  use WebsiteWeb.ConnCase, async: true
  use ExUnitProperties, async: true
  import StreamData
  alias WebsiteWeb.ErrorHelpers

  @max_run_time Application.get_env(:ex_unit, :test_timings, max_run_time: 500)[:max_run_time]
  @max_runs Application.get_env(:ex_unit, :test_timings, max_runs: 1_000_000_000)[:max_runs]

  test "translates known errors" do
    # assert WebsiteWeb.ErrorHelpers.translate_error({"some known message", []})
  end

  property "leaves unknown errors alone" do
    check all message <- string(:printable) do
      t_msg = ErrorHelpers.translate_error({"test " <> message, []})
      assert t_msg == "test " <> message
    end
  end

  property "translates plurals correctly" do
    check all count <- one_of([constant(0), positive_integer()]),
              max_run_time: @max_run_time,
              max_runs: @max_runs do
      t_msg = ErrorHelpers.translate_error({"test %{count}", [count: count]})
      assert t_msg == "test " <> Integer.to_string(count)
    end

    # negative integers should always raise
    check all invalid_count <- positive_integer() |> map(fn x -> x * -1 end),
              max_run_time: @max_run_time,
              max_runs: @max_runs do
      assert_raise FunctionClauseError, fn ->
        ErrorHelpers.translate_error({"test %{count}", [count: invalid_count]})
      end
    end
  end
end
