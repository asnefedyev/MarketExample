using MarketExample.Models.Entity;
using Microsoft.EntityFrameworkCore;
using System.Reflection.Metadata;

namespace MarketExample.Services.Common.Implements.Contexts
{
    public class ExampleDbContext : DbContext
    {       
        public DbSet<ProductInfoEntity> ValidationsProp { get; set; }
        public DbSet<ProductEntity> Products { get; set; }
        public DbSet<ProductVersionEntity> ProductVersions { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ProductInfoEntity>()
                .ToTable(tb => tb.UseSqlOutputClause(false));
            modelBuilder.Entity<ProductEntity>()
                .ToTable(tb => tb.UseSqlOutputClause(false));
            modelBuilder.Entity<ProductVersionEntity>()
                .ToTable(tb => tb.UseSqlOutputClause(false));

            modelBuilder.Entity<ProductEntity>()
                .HasKey(p => p.ID);

            modelBuilder.Entity<ProductEntity>()
                .HasIndex(p => p.Name)
                .IsUnique();

            modelBuilder.Entity<ProductVersionEntity>()
                .HasKey(pv => pv.ID);

            modelBuilder.Entity<ProductVersionEntity>()
                .HasOne(pv => pv.Product)
                .WithMany(p => p.ProductVersions)
                .HasForeignKey(pv => pv.ProductID)
                .OnDelete(DeleteBehavior.Cascade);
        }
        public ExampleDbContext(DbContextOptions<ExampleDbContext> options) : base(options) { }
    }
}