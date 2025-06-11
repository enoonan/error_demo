defmodule ErrorDemo.Demo do
  use Ash.Domain

  resources do
    resource ErrorDemo.Demo.Toy
    resource ErrorDemo.Demo.Child
    resource ErrorDemo.Demo.Parent
    resource ErrorDemo.Demo.GrandPappy
  end

  defmodule Toy do
    use Ash.Resource, domain: ErrorDemo.Demo, data_layer: AshPostgres.DataLayer

    postgres do
      repo ErrorDemo.Repo
      table "toys"
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
      default_accept :*
    end

    relationships do
      belongs_to :child, ErrorDemo.Demo.Child, public?: true
    end

    attributes do
      uuid_v7_primary_key :id
    end
  end

  defmodule Child do
    use Ash.Resource, domain: ErrorDemo.Demo, data_layer: AshPostgres.DataLayer

    postgres do
      repo ErrorDemo.Repo
      table "children"
    end

    relationships do
      belongs_to :parent, ErrorDemo.Demo.Parent, public?: true
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
      default_accept :*
    end

    attributes do
      uuid_v7_primary_key :id
    end

    calculations do
      calculate :foo, :string, ErrorDemo.Demo.CalcFoo
      calculate :bar, :string, ErrorDemo.Demo.CalcBar
      calculate :baz, :string, ErrorDemo.Demo.CalcBaz
    end
  end

  defmodule Parent do
    use Ash.Resource, domain: ErrorDemo.Demo, data_layer: AshPostgres.DataLayer

    postgres do
      repo ErrorDemo.Repo
      table "parents"
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
      default_accept :*
    end

    attributes do
      uuid_v7_primary_key :id
    end

    relationships do
      has_many :child, ErrorDemo.Demo.Child, public?: true
      belongs_to :grandpappy, ErrorDemo.Demo.GrandPappy, public?: true
    end
  end

  defmodule GrandPappy do
    use Ash.Resource, domain: ErrorDemo.Demo, data_layer: AshPostgres.DataLayer

    postgres do
      repo ErrorDemo.Repo
      table "grandpappies"
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
    end

    attributes do
      uuid_v7_primary_key :id
    end

    relationships do
      has_many :parent, ErrorDemo.Demo.Parent,
        public?: true,
        destination_attribute: :grandpappy_id

      has_many :grandchild_toys, ErrorDemo.Demo.Toy do
        no_attributes? true
        public? true
        filter expr(child.parent.grandpappy_id == parent(id))
      end
    end
  end

  defmodule CalcFoo do
    use Ash.Resource.Calculation

    @impl true
    def load(_, _, _) do
      [
        parent: [grandpappy: [:grandchild_toys]]
      ]
    end

    @impl true
    def calculate(records, _, _) do
      records |> Enum.map(fn _ -> "foo" end)
    end
  end

  defmodule CalcBar do
    use Ash.Resource.Calculation

    @impl true
    def load(_, _, _) do
      [
        parent: [grandpappy: [:grandchild_toys]]
      ]
    end

    @impl true
    def calculate(records, _, _) do
      records |> Enum.map(fn _ -> "bar" end)
    end
  end

  defmodule CalcBaz do
    use Ash.Resource.Calculation

    @impl true
    def load(_, _, _) do
      [
        parent: [grandpappy: [:grandchild_toys]]
      ]
    end

    @impl true
    def calculate(records, _, _) do
      records |> Enum.map(fn _ -> "baz" end)
    end
  end
end
