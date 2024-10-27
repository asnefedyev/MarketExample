using System.ComponentModel.DataAnnotations.Schema;

namespace MarketExample.Models.Entity
{
    [Table("ProductVersion", Schema = "dbo")]
    public class ProductVersionEntity
    {
        public Guid ID { get; set; }
        public Guid ProductID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime CreatingDate { get; set; }
        public float Width { get; set; }
        public float Height { get; set; }
        public float Length { get; set; }
        public virtual ProductEntity Product { get; set; }
    }
}