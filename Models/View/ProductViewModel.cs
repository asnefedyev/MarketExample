using System.Text.Json.Serialization;

namespace MarketExample.Models.View
{
    public class ProductViewModel
    {
        [JsonPropertyName("productId")]
        public Guid? Uid { get; set; }

        [JsonPropertyName("productName")]
        public string Name { get; set; }

        [JsonPropertyName("productDescription")]
        public string? Description { get; set; }
    }
}