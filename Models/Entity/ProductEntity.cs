using System.ComponentModel.DataAnnotations.Schema;

namespace MarketExample.Models.Entity
{
    [Table("Product", Schema = "dbo")]
    public class ProductEntity
    {
        public Guid? ID { get; set; } 
        public string Name { get; set; } 
        public string? Description { get; set; }
        public virtual ICollection<ProductVersionEntity> ProductVersions { get; set; }

        public ProductEntity()
        {
            ProductVersions = new HashSet<ProductVersionEntity>();
        }
    }
}