using Microsoft.AspNetCore;

namespace ExampleSource;

public class Program
{
    public static void Main(string[] args)
    {
        var webhost = CreateWebHostBuilder(args);
        webhost.Build().Run();
    }

    public static IWebHostBuilder CreateWebHostBuilder(string[] args)
    {
        var configuration = new ConfigurationBuilder()
        .SetBasePath(Environment.GetEnvironmentVariable("EXAMPLE_FOR_HOME") ?? Directory.GetCurrentDirectory())
        .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
        .AddEnvironmentVariables()
        .Build();

        int basePort = int.Parse(configuration["Listener:BasePort"] ?? "0");

        List<string> listeningUrls = new List<string>();
        if (basePort >= 1) listeningUrls.Add($"http://0.0.0.0:{basePort}");
            else listeningUrls.Add($"http://localhost:5000");

        IWebHostBuilder builder =
        WebHost
        .CreateDefaultBuilder(args)
            .UseKestrel(options =>
            {
                options.Limits.MaxConcurrentConnections = 10000;
                options.Limits.KeepAliveTimeout = TimeSpan.FromMinutes(2);
                options.Limits.RequestHeadersTimeout = TimeSpan.FromMinutes(2);
            })
            .ConfigureAppConfiguration((context, config) =>
            {
                config.AddConfiguration(configuration);
            })
            .UseUrls(listeningUrls.ToArray())
            .UseIISIntegration()
            .UseStartup<Startup>();
        return builder;
    }
}