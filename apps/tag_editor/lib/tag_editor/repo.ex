defmodule TagEditor.Repo do
  use Ecto.Repo,
    otp_app: :tag_editor,
    adapter: Ecto.Adapters.Postgres
end
