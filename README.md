# ErrorDemo

A simple Ash app that demonstrates a minimal example of an error with loading complex relationships.

Using Elixir 1.18.2 and Erlang/OTP 27.

```elixir

  defp deps do
    [
      {:sourceror, "~> 1.8", only: [:dev, :test]},
      {:ash_postgres, "~> 2.0"},
      {:ash, "~> 3.0"},
      {:igniter, "~> 0.6", only: [:dev, :test]}
    ]
  end
```

## Description

I'm running into an error that's very similar to one I encountered before.

- **Ash Code**: [`lib/error_demo/demo.ex`](./lib/error_demo/demo.ex).
- **Test Code**: [`test/error_demo_test.exs`](./test/error_demo_test.exs)

## Resource Structure / Deets

`Grandpappy > has_many > Parent > has_many > Child > has_many Toy`

`Grandparent` also `has_many :grandchild_toys` via a `no_attributes?: true` relationship:

```elixir
      has_many :grandchild_toys, ErrorDemo.Demo.Toy do
        no_attributes? true
        public? true
        filter expr(child.parent.grandpappy_id == parent(id))
      end
```

## The Error

When I add three calculations (`:foo, :bar and :baz`) to `Child`, and all three need to load the grandchild toys like so...

```elixir
    @impl true
    def load(_, _, _) do
      [
        parent: [grandpappy: [:grandchild_toys]]
      ]
    end
```

... the following code results in an exception:

```elixir
    child |> Ash.load([:foo, :bar, :baz])

    # raises:

    %Ash.Error.Unknown.UnknownError{
      error: "** (KeyError) key :grandpappy not found in: %ErrorDemo.Demo.Child
     ...
    }
```

Loading only two calculations is fine. I also experimented with adding toys to the parent instead of the child, to see if the error would replicate with a smaller relationship graph. It did not. As far as I can tell this is the de minimis example to replicate the error.

The following code also works:

```elixir
  child = child |> Ash.load!([:foo, :bar]) |> Ash.load!(:baz)
```

So it only seems to happen when loading all three at the same time.
