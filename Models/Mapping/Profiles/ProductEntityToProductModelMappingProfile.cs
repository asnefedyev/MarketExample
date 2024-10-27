using AutoMapper;
using MarketExample.Models.Backend;
using MarketExample.Models.Entity;

namespace MarketExample.Models.Mapping.Profiles
{
    public class ProductEntityToProductModelMappingProfile : Profile
    {
        public ProductEntityToProductModelMappingProfile()
        {
            CreateMap<ProductEntity, ProductModel>()
                .ForMember(dest => dest.Uid, opt => opt.MapFrom(src => src.ID ?? Guid.Empty))
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Name))
                .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description ?? ""));
        }
    }
}