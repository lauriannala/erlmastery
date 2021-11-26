defmodule Erlmastery.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, read_after_writes: true}
      @foreign_key_type :binary_id
    end
  end
end
