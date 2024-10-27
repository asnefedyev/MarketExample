using MarketExample.Models.Backend;
using MarketExample.Models.Entity;
using MarketExample.Services.Common.Contracts;
using MarketExample.Services.Common.SqlConnections;
using MarketExample.Services.CustomData.Contracts;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Data;

namespace MarketExample.Services.CustomData.Implements
{
    public class ProductDataService : IProductDataService
    {
        private readonly IDataEngineService _dataService;
        public ProductDataService(IServiceProvider services) 
        {
            _dataService = services.GetService<IDataEngineServiceBuilder>()
                .GetDalService<DefaultConnection>();
        }

        public List<ProductInfoEntity> GetProductInfo(string productName, string productVersionName, float minVolume, float maxVolume)
        {
            Func<DbContext, List<ProductInfoEntity>> processing = (context) =>
            {

                var productNameParam = new SqlParameter("@productName", SqlDbType.VarChar) { Value = productName };
                var productVersionNameParam = new SqlParameter("@productVersionName", SqlDbType.VarChar) { Value = productVersionName };
                var minVolumeParam = new SqlParameter("@minVolume", SqlDbType.Real) { Value = minVolume };
                var maxVolumeParam = new SqlParameter("@maxVolume", SqlDbType.Real) { Value = maxVolume };

                var prodInfo = context.Set<ProductInfoEntity>();
                return prodInfo is null
                    ? throw new Exception("Не обнаружен entity!")
                    : prodInfo
                    .FromSql($"SELECT * FROM dbo.get_versions_products({productNameParam}, {productVersionNameParam}, {minVolumeParam}, {maxVolumeParam})")
                    .ToList();
            };
            return _dataService.GetEntityList(processing);
        }

        public void ProductAdd(ProductModel product)
        {
            Guid guid = Guid.NewGuid();
            Action<DbContext> processing = (context) =>
            {
                List<ProductVersionEntity> productVersionEntityList = new();
                foreach (var item in product.ProductVersionList)
                {
                    productVersionEntityList.Add(new ProductVersionEntity
                    {
                        ID = Guid.NewGuid(),
                        Name = item.Name,
                        CreatingDate = DateTime.Now,
                        Description = item.Description,
                        Height = item.Height,
                        Width = item.Width,
                        Length = item.Length,
                        ProductID = guid
                    });
                }

                var prodInfo = context.Set<ProductEntity>();
                prodInfo.Add(new ProductEntity
                {
                    ID = guid,
                    Description = product.Description,
                    Name = product.Name,
                    ProductVersions = productVersionEntityList
                });
                context.SaveChanges();
            };
            _dataService.ChangeEntityList(processing);
        }

        public void ProductUpd(ProductModel product)
        {
            Action<DbContext> processing = (context) =>
            {
                var prodInfo = context.Set<ProductEntity>();
                var prodVersionInfo = context.Set<ProductVersionEntity>();
                var existingProduct = prodInfo
                        .Include(p => p.ProductVersions)
                        .FirstOrDefault(p => p.ID == product.Uid);

                if (existingProduct is null)
                {
                    throw new Exception("Продукт не найден!");
                }

                existingProduct.Name = product.Name;
                existingProduct.Description = product.Description;

                var existingVersionIds = existingProduct.ProductVersions.Select(v => v.ID).ToList();
                
                foreach (var updatedVersion in product.ProductVersionList)
                {
                    if (existingVersionIds.Contains(updatedVersion.Uid))
                    {
                        var existingVersion = existingProduct.ProductVersions.First(v => v.ID == updatedVersion.Uid);
                        existingVersion.Name = updatedVersion.Name;
                        existingVersion.Description = updatedVersion.Description;
                        existingVersion.Width = updatedVersion.Width;
                        existingVersion.Height = updatedVersion.Height;
                        existingVersion.Length = updatedVersion.Length;
                        existingVersion.CreatingDate = updatedVersion.CreatingDate;
                    };
                }
                context.SaveChanges();
            };
            _dataService.ChangeEntityList(processing);
        }

        public void ProductSingleAdd(ProductModel product)
        {
            Guid guid = Guid.NewGuid();
            Action<DbContext> processing = (context) =>
            {
                var prodInfo = context.Set<ProductEntity>();
                if (prodInfo is null) throw new Exception("Entity не найден!");

                prodInfo.Add(new ProductEntity
                {
                    ID = Guid.NewGuid(),
                    Name = product.Name,
                    Description = product.Description
                });
                context.SaveChanges();
            };
            _dataService.ChangeEntityList(processing);
        }

        public void ProductSingleUpd(ProductModel product)
        {
            Guid guid = Guid.NewGuid();
            Action<DbContext> processing = (context) =>
            {
                var prodInfo = context.Set<ProductEntity>();
                if (prodInfo is null) throw new Exception("Entity не найден!");

                var prodSingle = prodInfo.Where(it => it.ID == product.Uid).FirstOrDefault();
                if (prodSingle is null)
                {
                    throw new Exception("Продукт не найден!");
                }

                prodSingle.Name = product.Name;
                prodSingle.Description = product.Description;
                context.SaveChanges();
            };
            _dataService.ChangeEntityList(processing);
        }

        public void ProductSingleDel(Guid productId)
        {
            Guid guid = Guid.NewGuid();
            Action<DbContext> processing = (context) =>
            {
                var prodInfo = context.Set<ProductEntity>();
                if (prodInfo is null) throw new Exception("Entity не найден!");

                var prodSingle = prodInfo.Where(it => it.ID == productId).FirstOrDefault();
                if (prodSingle is null)
                {
                    throw new Exception("Продукт не найден!");
                }
                prodInfo.Remove(prodSingle);
                context.SaveChanges();
            };
            _dataService.ChangeEntityList(processing);
        }

        public List<ProductEntity> ProductsGet(string productName)
        {
            Func<DbContext, List<ProductEntity>> processing = (context) =>
            {
                var prodInfo = context.Set<ProductEntity>();
                var result = prodInfo.Where(it => it.Name.Contains(productName));
                return result.ToList();
            };
            return _dataService.GetEntityList(processing);
        }
    }
}