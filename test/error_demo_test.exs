defmodule ErrorDemoTest do
  use ExUnit.Case
  alias ErrorDemo.Demo.{Child, Parent, GrandPappy}
  use ErrorDemo.DataCase

  test "loads foo and bar" do
    {:ok, grandpappy} = Ash.Changeset.for_create(GrandPappy, :create) |> Ash.create(%{})
    grandpappy.id |> dbg

    {:ok, parent} =
      Ash.Changeset.for_create(Parent, :create, %{"grandpappy_id" => grandpappy.id})
      |> Ash.create()

    {:ok, child} =
      Ash.Changeset.for_create(Child, :create, %{"parent_id" => parent.id})
      |> Ash.create()

    try do
      child |> Ash.load([:foo, :baz])
    rescue
      err ->
        err |> dbg
        assert "an exception was thrown" == false
    end

    assert grandpappy |> is_struct(GrandPappy)
    assert parent |> is_struct(Parent)
    assert child |> is_struct(Child)
  end
end
