defmodule ErrorDemoTest do
  use ExUnit.Case
  alias ErrorDemo.Demo.{Child, Parent, GrandPappy}
  use ErrorDemo.DataCase

  setup do
    {:ok, grandpappy} = Ash.Changeset.for_create(GrandPappy, :create) |> Ash.create(%{})

    {:ok, parent} =
      Ash.Changeset.for_create(Parent, :create, %{"grandpappy_id" => grandpappy.id})
      |> Ash.create()

    {:ok, child} =
      Ash.Changeset.for_create(Child, :create, %{"parent_id" => parent.id})
      |> Ash.create()

    %{child: child}
  end

  test "loads foo, bar and baz at the same time", %{child: child} do
    try do
      child = child |> Ash.load([:foo, :bar, :baz])
    rescue
      err ->
        err |> dbg
        refute "an exception was thrown"
    end

    assert child |> is_struct(Child)
  end

  test "loads foo, bar and baz separately", %{child: child} do
    child = child |> Ash.load!([:foo, :bar]) |> Ash.load!(:baz)
    assert child.foo == "foo"
    assert child.bar == "bar"
    assert child.baz == "baz"
  end
end
