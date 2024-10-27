using MarketExample.Models.Api;
using MarketExample.Models.Backend;
using MarketExample.Models.Common;
using MarketExample.Models.View;
using MarketExample.Services.Common.Contracts;
using MarketExample.Services.CustomBackend.Contracts;
using Microsoft.AspNetCore.Mvc;
namespace Example.Controllers;

[Route("example")]
[ApiController()]
public class ExampleController : Controller
{
    private readonly IDatabaseConnection _conn;
    private readonly IProductService _productService;

    public ExampleController(IServiceProvider serviceProvider)
    {
        _conn = serviceProvider.GetService<IDatabaseConnection>();
        _productService = serviceProvider.GetService<IProductService>();
    }

    /// <summary>
    /// Возвращает сведения об экземпляре приложения
    /// </summary>
    [HttpGet("products")]
    public async Task<StandartResponseMessage<List<ProductInfoModel>>> GetProductsInfo(string productName, string productVersionName, float minVolume, float maxVolume)
    {
        return await Task.Run(() =>
        {
            List<ProductInfoModel> res = new();
            try
            {
                res = _productService.GetProductInfo(productName, productVersionName, minVolume, maxVolume);
                return new StandartResponseMessage<List<ProductInfoModel>>
                {
                    Code = "200",
                    Count = -1,
                    Message = "Успех",
                    Value = res
                };
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return new StandartResponseMessage<List<ProductInfoModel>>
                {
                    Code = "200",
                    Count = -1,
                    Message = "Успех",
                    Value = null
                };
            }
        });
    }

    /// <summary>
    /// Добавление продукта
    /// </summary>
    [HttpPut("product/add")]
    public async void ProductAdd(ProductApiModel product)
    {
        await Task.Run(() =>
        {
            _productService.ProductAdd(product);
        });
    }

    /// <summary>
    /// Обновление продукта
    /// </summary>
    [HttpPost("product/upd")]
    public async Task ProductUpd(ProductApiModel product)
    {
        await Task.Run(() =>
        {
            _productService.ProductUpd(product);
        });
    }

    /// <summary>
    /// Добавление продукта (без версии)
    /// </summary>
    [HttpPut("product/headadd")]
    public async void ProductSingleAdd(ProductApiModel product)
    {
        await Task.Run(() =>
        {
            _productService.ProductSingleAdd(product);
        });
    }

    /// <summary>
    /// Обновление продукта (без версии)
    /// </summary>
    [HttpPost("product/headupd")]
    public async void ProductSingleUpd(ProductApiModel product)
    {
        await Task.Run(() =>
        {
            _productService.ProductSingleUpd(product);
        });
    }

    /// <summary>
    /// Удаление продукта (со всеми версиями, поскольку удаление каскадное со стороны T-SQL)
    /// </summary>
    [HttpDelete("product/headrem")]
    public async void ProductSingleRem(Guid productId)
    {
        await Task.Run(() =>
        {
            _productService.ProductSingleDel(productId);
        });
    }

    /// <summary>
    /// Возвращает сведения о продуктах
    /// </summary>
    [HttpGet("productlist")]
    public async Task<StandartResponseMessage<List<ProductViewModel>>> GetProductList(string productName)
    {
        return await Task.Run(() =>
        {
            List<ProductViewModel> res = new();
            try
            {
                res = _productService.ProductsGet(productName);
                return new StandartResponseMessage<List<ProductViewModel>>
                {
                    Code = "200",
                    Count = -1,
                    Message = "Успех",
                    Value = res
                };
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return new StandartResponseMessage<List<ProductViewModel>>
                {
                    Code = "200",
                    Count = -1,
                    Message = "Успех",
                    Value = null
                };
            }
        });
    }
}