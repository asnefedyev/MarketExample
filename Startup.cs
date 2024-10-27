using Microsoft.AspNetCore.ResponseCompression;
using System.IO.Compression;
using Microsoft.Extensions.ObjectPool;
using MarketExample.Services.Common.Contracts;
using MarketExample.Services.Common.Implements;
using MarketExample.Services.CustomData.Contracts;
using MarketExample.Services.CustomData.Implements;
using MarketExample.Services.CustomBackend.Contracts;
using Microsoft.EntityFrameworkCore;
using MarketExample.Services.Common.Implements.Contexts;
using MarketExample.Models.Mapping.Configurations;

namespace ExampleSource;

public class Startup
{
    public Startup(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    public IConfiguration Configuration { get; }

    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSingleton<ObjectPoolProvider, DefaultObjectPoolProvider>();
        services.AddSingleton<ISqlDbConnectionFactoryBuilder, SqlDbConnectionFactoryBuilder>();
        services.AddSingleton<IDatabaseConnection, SqlDatabaseConnection>();
        services.AddDbContext<ExampleDbContext>(options => options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));
        services.AddSingleton<IDataEngineServiceBuilder, DataEngineServiceBuilder>();
        services.AddTransient<IDataEngineService, SqlDataEngineService>();
        services.AddSingleton<AutoMapperConfiguration>();
        services.AddSingleton<IProductDataService, ProductDataService>();
        services.AddSingleton<IProductService, ProductService>();

        /*
         * Можно использовать свой фильтр логирования
        services.AddScoped<LogAttribute>();
        services.AddControllersWithViews(options =>
        {
            options.Filters.AddService<LogAttribute>();
        });
        */

        /*
         * Можно добавить свой провайдер логирования
        services.AddLogging(builder =>
        {
            builder.ClearProviders();
            builder.AddProvider(new DatabaseLoggerProvider(services.BuildServiceProvider()));
        });
        */

        services.Configure<GzipCompressionProviderOptions>(options => options.Level = CompressionLevel.Fastest);
        services.AddResponseCompression(options =>
        {
            options.Providers.Add<GzipCompressionProvider>();
            options.EnableForHttps = true;
        });

        services.AddMvc().AddControllersAsServices();
        services.AddRouting();

        var serviceProvider = services.BuildServiceProvider();

        /*
        services.AddDbContext<AppDbContext>(options =>
        {
            var conn = services.BuildServiceProvider().GetService<IDatabaseConnection>();
            options.UseNpgsql(conn.GetDbConnection().ConnectionString);
        }, ServiceLifetime.Singleton);
        */

        services.AddCors(options =>
        {
            options.AddPolicy("ExamplePolicy",
                builder =>
                {
                    builder
                        .AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader();
                });
        });

        services.AddHttpContextAccessor();
        services.AddHttpClient("myClient", client =>
        {
            client.Timeout = TimeSpan.FromSeconds(300);
        });
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        /*
        app.UseRequestLocalization(new RequestLocalizationOptions
        {
            DefaultRequestCulture = new RequestCulture("ru-RU"),  
        });
        */

        app
           .UseStaticFiles()
           .UseResponseCompression()
           .UseHttpsRedirection()
           .UseRouting()
           .UsePathBase("/api")
           .UseCors("ExamplePolicy")
           //.UseAuthentication()
           //.UseAuthorization()
           .Use(async (context, next) =>
           {
               context.Request.EnableBuffering();
               await next();
           })
           .UseEndpoints(endpoints =>
           {
               endpoints.MapControllers();
           });
    }
}