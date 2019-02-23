defmodule Examples.Advisors.CreateAndCancelPendingOrder.Advisor do
  use Tai.Advisor

  def handle_inside_quote(venue_id, product_symbol, _inside_quote, _changes, state) do
    if Tai.Trading.OrderStore.count() == 0 do
      Tai.Trading.Orders.create(%Tai.Trading.OrderSubmissions.BuyLimitGtc{
        venue_id: venue_id,
        account_id: :main,
        product_symbol: product_symbol,
        price: Decimal.new("100.1"),
        qty: Decimal.new("0.1"),
        post_only: false,
        order_updated_callback: &order_updated/2
      })
    end

    {:ok, state.store}
  end

  def order_updated(
        %Tai.Trading.Order{status: :enqueued},
        %Tai.Trading.Order{status: :open} = open_order
      ) do
    Tai.Trading.Orders.cancel(open_order)
  end

  def order_updated(_previous_order, _updated_order), do: nil
end
