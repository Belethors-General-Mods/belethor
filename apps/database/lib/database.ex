defmodule Database do
  @moduledoc """
  Documentation for Database.
  """

  alias Common.Struct
  alias Database.Schema
  alias Database.Repo
  alias Ecto.Changeset

  @doc """
  create a new mod in the database.

  fails if there is already a mod with the same name.
  """
  def write_mod(%Struct.Mod{} = mod) do
    mod_schema = Schema.Mod.struct2schema(mod)
    if Repo.exists?(Schema.Mod, name: mod.name) do
      # update existing tuple in the database
      #TODO !
    else
      # a new tuple in the database
      case Repo.insert(mod) do
        {:ok, _struct} -> :ok
        {:error, _changeset} -> :error
      end
    end
  end

  def read_mod(name) when is_bitstring(name) do
    case Repo.get_by(Schema.Mod, name: name) do
      nil -> :not_found
      schema -> Schema.Mod.schema2struct(schema)
    end
  end

  def delete_mod(%Struct.Mod{} = mod) do
    #TODO check wether deleted mod is the same as the one the DB
    delete_mod(mod.name)
  end

  def delete_mod(name) when is_bitstring(name) do
    case Repo.get_by(Schema.Mod, name: name) do
      nil -> :not_found
      schema -> delete_mod_schema(schema)
    end
  end

  defp delete_mod_schema(%Schema.Mod{} = mod) do
    case Repo.delete(mod) do
      {:ok, _struct} -> :ok
      {:error, _changeset} -> :error
    end
  end

end
