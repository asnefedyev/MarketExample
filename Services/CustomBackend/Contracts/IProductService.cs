using MarketExample.Models.Api;
using MarketExample.Models.Backend;
using MarketExample.Models.View;

namespace MarketExample.Services.CustomBackend.Contracts
{
    public interface IProductService
    {
        public List<ProductInfoModel> GetProductInfo(string productName, string productVersionName, float minVolume, float maxVolume);
        public void ProductAdd(ProductApiModel product);
        public void ProductUpd(ProductApiModel product);
        public void ProductSingleAdd(ProductApiModel product);
        public void ProductSingleUpd(ProductApiModel product);
        public void ProductSingleDel(Guid productId);
        public List<ProductViewModel> ProductsGet(string productName);
    }
}