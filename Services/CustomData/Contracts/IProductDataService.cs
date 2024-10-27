using MarketExample.Models.Backend;
using MarketExample.Models.Entity;

namespace MarketExample.Services.CustomData.Contracts
{
    public interface IProductDataService
    {
        public List<ProductInfoEntity> GetProductInfo(string productName, string productVersionName, float minVolume, float maxVolume);
        public void ProductAdd(ProductModel product);
        public void ProductUpd(ProductModel product);
        public void ProductSingleAdd(ProductModel product);
        public void ProductSingleUpd(ProductModel product);
        public void ProductSingleDel(Guid productId);
        public List<ProductEntity> ProductsGet(string productName);
    }
}