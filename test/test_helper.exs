{:ok, _pid} = Dummy.Repo.start_link()
{:ok, _pid} = Dummy.Endpoint.start_link()

Ecto.Adapters.SQL.Sandbox.mode(Dummy.Repo, :manual)

ExUnit.start()
