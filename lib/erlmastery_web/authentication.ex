defmodule ErlmasteryWeb.Authentication do
  use Guardian, otp_app: :erlmastery

  alias Erlmastery.Accounts
  alias Erlmastery.Accounts.User

  def subject_for_token(%User{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_session}
  end
end
