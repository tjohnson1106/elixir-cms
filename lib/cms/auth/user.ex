defmodule Cms.Auth.User do
  # imports
  # schema "users"

  @create_fields ~w(name password email)a
  @optional_fields ~w(is_admin)a

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, @create_fields ++ @optional_fields)
    |> validate_required(@create_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 3)
    |> validate_length(:password, min: 3)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
