defmodule PollutiondbWeb.PageController do
  use PollutiondbWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
