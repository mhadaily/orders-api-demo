# Globomantics.Orders.Contracts

This package contains the order summary contract used by the fictional
`orders-api` sample.

`OrderRules.Get(id)` returns an `OrderSummary` for a positive order ID. It
throws `ArgumentOutOfRangeException` when the ID is zero or negative.

```csharp
using Globomantics.Orders.Contracts;

var order = OrderRules.Get(42);
Console.WriteLine(order.Status); // ready
```
