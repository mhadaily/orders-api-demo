namespace Globomantics.Orders.Contracts;

public sealed record OrderSummary(int Id, string Status);

public static class OrderRules
{
    public static OrderSummary Get(int id)
    {
        if (id <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(id));
        }
        return new OrderSummary(id, "ready");
    }
}
