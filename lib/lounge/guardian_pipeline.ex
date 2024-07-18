defmodule Lounge.GuardianPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :lounge,
    module: Lounge.Guardian,
    error_handler: Lounge.GuardianErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
