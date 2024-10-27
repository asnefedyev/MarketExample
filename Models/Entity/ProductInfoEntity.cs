using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketExample.Models.Entity
{
    public class ProductInfoEntity
    {
        [Key]
        [Column("productVersionUID")]
        public Guid ProductVersionUid { get; set; }

        [Column("productName")]
        public string ProductName { get; set; }

        [Column("productVersionName")]
        public string ProductVersionName { get; set; }

        [Column("Width")]
        public float Width { get; set; }

        [Column("Height")]
        public float Height { get; set; }

        [Column("Length")]
        public float Length { get; set; }
    }
}