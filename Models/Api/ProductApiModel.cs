using System.Text.Json.Serialization;

namespace MarketExample.Models.Api
{
    public class ProductApiModel
    {
        [JsonPropertyName("uid")]
        public Guid? Uid { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("description")]
        public string? Description { get; set; }

        [JsonPropertyName("productVersionList")]
        public List<ProductVersionApiModel>? ProductVersionList { get; set; }
    }
}