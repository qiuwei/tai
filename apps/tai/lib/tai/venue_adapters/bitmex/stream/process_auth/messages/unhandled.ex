defmodule Tai.VenueAdapters.Bitmex.Stream.ProcessAuth.Messages.Unhandled do
  alias __MODULE__
  alias Tai.VenueAdapters.Bitmex.Stream.ProcessAuth

  @type t :: %Unhandled{msg: map}

  @enforce_keys ~w(msg)a
  defstruct ~w(msg)a

  defimpl ProcessAuth.Message do
    def process(message, received_at, state) do
      %Tai.Events.StreamMessageUnhandled{
        venue_id: state.venue,
        msg: message.msg,
        received_at: received_at
      }
      |> TaiEvents.warn()

      :ok
    end
  end
end
