namespace MarketExample.Models.Backend
{
    public class ProductModel
    {
        public Guid? Uid { get; set; } 
        public string Name { get; set; } 
        public string? Description { get; set; }
        public List<ProductVersionModel>? ProductVersionList { get; set; }
    }
}