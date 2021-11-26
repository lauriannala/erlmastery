defmodule Erlmastery.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :id, read_after_writes: true}
    end
  end
end
