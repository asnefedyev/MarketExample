using System.Text.Json.Serialization;

namespace MarketExample.Models.Api
{
    public class ProductVersionApiModel
    {
        [JsonPropertyName("productUid")]
        public Guid Uid { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("description")]
        public string Description { get; set; }

        [JsonPropertyName("createDate")]
        public DateTime CreatingDate { get; set; }

        [JsonPropertyName("width")]
        public float Width { get; set; }

        [JsonPropertyName("height")]
        public float Height { get; set; }

        [JsonPropertyName("length")]
        public float Length { get; set; }
    }
}
