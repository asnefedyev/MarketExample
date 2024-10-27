using AutoMapper;
using MarketExample.Models.Backend;
using MarketExample.Models.Entity;

namespace MarketExample.Models.Mapping.Profiles
{
    public class ProductInfoMappingProfile : Profile
    {
        public ProductInfoMappingProfile()
        {
            CreateMap<ProductInfoEntity, ProductInfoModel>()
                .ForMember(dest => dest.ProductVersionUid, opt => opt.MapFrom(src => src.ProductVersionUid))
                .ForMember(dest => dest.ProductName, opt => opt.MapFrom(src => src.ProductName))
                .ForMember(dest => dest.ProductVersionName, opt => opt.MapFrom(src => src.ProductVersionName))
                .ForMember(dest => dest.Width, opt => opt.MapFrom(src => src.Width))
                .ForMember(dest => dest.Height, opt => opt.MapFrom(src => src.Height))
                .ForMember(dest => dest.Length, opt => opt.MapFrom(src => src.Length));
        }
    }
}