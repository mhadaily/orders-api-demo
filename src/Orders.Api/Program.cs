using Globomantics.Orders.Contracts;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));
app.MapGet("/orders/{id:int}", IResult (int id) =>
    id <= 0 ? Results.BadRequest() : Results.Ok(OrderRules.Get(id)));
app.MapGet("/release", IResult () =>
{
    var file = Path.Combine(app.Environment.ContentRootPath, "release-evidence.txt");
    return File.Exists(file)
        ? Results.Text(File.ReadAllText(file), "text/plain")
        : Results.NotFound();
});

app.Run();
