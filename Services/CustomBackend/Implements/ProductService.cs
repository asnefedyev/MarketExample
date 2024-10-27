using AutoMapper;
using MarketExample.Models.Api;
using MarketExample.Models.Backend;
using MarketExample.Models.Mapping.Configurations;
using MarketExample.Models.View;
using MarketExample.Services.CustomBackend.Contracts;
using MarketExample.Services.CustomData.Contracts;

namespace MarketExample.Services.CustomData.Implements
{
    public class ProductService : IProductService
    {
        private readonly IProductDataService _productDataService;
        private readonly AutoMapperConfiguration _mapConfig;
        public ProductService(IServiceProvider services) 
        {
            _productDataService = services.GetService<IProductDataService>();
            _mapConfig = services.GetService<AutoMapperConfiguration>();
        }

        public List<ProductInfoModel> GetProductInfo(string productName, string productVersionName, float minVolume, float maxVolume)
        {
            var prodInfo = _productDataService.GetProductInfo(productName, productVersionName, minVolume, maxVolume);
            return _mapConfig.GetMapper().Map<List<ProductInfoModel>>(prodInfo);
        }

        public void ProductAdd(ProductApiModel product)
        {
            var prod = _mapConfig.GetMapper().Map<ProductModel>(product);
            _productDataService.ProductAdd(prod);
        }

        public void ProductUpd(ProductApiModel product)
        {
            var prod = _mapConfig.GetMapper().Map<ProductModel>(product);
            _productDataService.ProductUpd(prod);
        }

        public void ProductSingleAdd(ProductApiModel product)
        {
            var prod = _mapConfig.GetMapper().Map<ProductModel>(product);
            _productDataService.ProductSingleAdd(prod);
        }

        public void ProductSingleUpd(ProductApiModel product)
        {
            var prod = _mapConfig.GetMapper().Map<ProductModel>(product);
            _productDataService.ProductSingleUpd(prod);
        }

        public void ProductSingleDel(Guid productId)
        {
            _productDataService.ProductSingleDel(productId);
        }

        public List<ProductViewModel> ProductsGet(string productName)
        {
            var products = _productDataService.ProductsGet(productName);
            var productsModel = _mapConfig.GetMapper().Map<List<ProductModel>>(products);
            var productsViewModel = _mapConfig.GetMapper().Map<List<ProductViewModel>>(productsModel);
            return productsViewModel;
        }
    }
}