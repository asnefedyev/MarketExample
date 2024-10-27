using AutoMapper;
using MarketExample.Models.Mapping.Profiles;

namespace MarketExample.Models.Mapping.Configurations
{
    public class AutoMapperConfiguration
    {
        private readonly IMapper _mapper;
        public AutoMapperConfiguration() 
        {
            var configuration = new MapperConfiguration(cfg =>
            {
                cfg.AddProfile<ProductInfoMappingProfile>();
                cfg.AddProfile<ProductApiModelToProductModelMappingProfile>();
                cfg.AddProfile<ProductVersionModelMappingProfile>();
                cfg.AddProfile<ProductEntityToProductModelMappingProfile>();
                cfg.AddProfile<ProductModelToProductViewModelMappingProfile>();
            });
            _mapper = configuration.CreateMapper();
        }
        public IMapper GetMapper()
        {
            return _mapper;
        }
    }
}