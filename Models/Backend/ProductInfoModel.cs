namespace MarketExample.Models.Backend
{
    public class ProductInfoModel
    {
        public Guid ProductVersionUid { get; set; }
        public string ProductName { get; set; }
        public string ProductVersionName { get; set; }
        public float Width { get; set; }
        public float Height { get; set; }
        public float Length { get; set; }
    }
}