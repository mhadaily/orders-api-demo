using Globomantics.Orders.Contracts;

try
{
    var order = OrderRules.Get(42);
    if (order.Id != 42 || order.Status != "ready")
    {
        throw new InvalidOperationException("positive order contract");
    }
    foreach (var invalid in new[] { 0, -1 })
    {
        try
        {
            OrderRules.Get(invalid);
            throw new InvalidOperationException("invalid ID accepted");
        }
        catch (ArgumentOutOfRangeException)
        {
            // Expected rejection from the shared rule.
        }
    }
    Console.WriteLine("PASS: positive order and invalid-ID checks");
    return 0;
}
catch (Exception error)
{
    Console.Error.WriteLine($"FAIL: {error.Message}");
    return 1;
}
