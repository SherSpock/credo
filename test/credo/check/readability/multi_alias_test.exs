defmodule Credo.Check.Readability.MultiAliasTest do
  use Credo.TestHelper

  @described_check Credo.Check.Readability.MultiAlias

  #
  # cases NOT raising issues
  #

  test "it should NOT report violation" do
    """
    defmodule Test do
      alias App.Module1
      alias App.Module2
    end
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  #
  # cases raising issues
  #

  test "it should report a violation" do
    """
    defmodule CredoSampleModule do
      alias App.Module2.{Module3}
    end
    """
    |> to_source_file
    |> assert_issue(@described_check)
  end

  test "it should report a violation for multiple expansions" do
    """
    defmodule CredoSampleModule do
      alias App.{Module1, Module2}
    end
    """
    |> to_source_file
    |> assert_issue(@described_check)
  end

  test "it should report a violation for multiple nested expansions" do
    """
    defmodule CredoSampleModule do
      alias App.{Module1.Submodule1, Module2}
    end
    """
    |> to_source_file
    |> assert_issue(@described_check, fn issue ->
      assert issue.trigger == "Module1.Submodule1"
    end)
  end
end
