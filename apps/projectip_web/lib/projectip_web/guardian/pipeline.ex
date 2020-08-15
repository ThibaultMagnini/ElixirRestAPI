defmodule ProjectipWeb.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :auth_web,
    error_handler: ProjectipWeb.ErrorHandler,
    module: ProjectipWeb.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
