defmodule Cms.Content.Post do
  # use Ecto.Schema
  # import Ecto.Changeset

  @derive {Phoenix.Param, key: :slug}

  def create_changeset(post, attrs) do
    post
    |> common_changeset(attrs)
    |> validate_required([:user_id, :cover])
  end

  def common_changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:title, :body, :published, :user_id])
    |> cast_attachments(attrs, [:cover])
    |> validate_required([:title, :body])
    |> validate_length(:title, min: 3)
    |> process_slug
  end

  # Private

  defp process_slug(%Ecto.Changeset{valid?: validity, changes: %{title: title}} = changeset) do
    case validity do
      true -> put_change(changeset, :slug, Slugger.slugify_downcase(title))
      false -> changeset
    end
  end

  defp process_slug(changeset), do: changeset
end
