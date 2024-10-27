using AutoMapper;
using MarketExample.Models.Backend;
using MarketExample.Models.View;

namespace MarketExample.Models.Mapping.Profiles
{
    public class ProductModelToProductViewModelMappingProfile : Profile
    {
        public ProductModelToProductViewModelMappingProfile()
        {
            CreateMap<ProductModel, ProductViewModel>()
                .ForMember(dest => dest.Uid, opt => opt.MapFrom(src => src.Uid))
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Name))
                .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description));
        }
    }
}