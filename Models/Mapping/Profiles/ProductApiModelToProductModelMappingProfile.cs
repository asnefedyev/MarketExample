using AutoMapper;
using MarketExample.Models.Api;
using MarketExample.Models.Backend;

namespace MarketExample.Models.Mapping.Profiles
{
    public class ProductApiModelToProductModelMappingProfile : Profile
    {
        public ProductApiModelToProductModelMappingProfile()
        {
            CreateMap<ProductApiModel, ProductModel>()
                .ForMember(dest => dest.Uid, opt => opt.MapFrom(src => src.Uid))
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Name))
                .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description));
        }
    }
}