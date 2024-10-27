using AutoMapper;
using MarketExample.Models.Api;
using MarketExample.Models.Backend;

namespace MarketExample.Models.Mapping.Profiles
{
    public class ProductVersionModelMappingProfile : Profile
    {
        public ProductVersionModelMappingProfile()
        {
            CreateMap<ProductVersionApiModel, ProductVersionModel>()
                .ForMember(dest => dest.Uid, opt => opt.MapFrom(src => src.Uid))
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Name))
                .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description))
                .ForMember(dest => dest.CreatingDate, opt => opt.MapFrom(src => src.CreatingDate))
                .ForMember(dest => dest.Width, opt => opt.MapFrom(src => src.Width))
                .ForMember(dest => dest.Height, opt => opt.MapFrom(src => src.Height))
                .ForMember(dest => dest.Length, opt => opt.MapFrom(src => src.Length));
        }
    }
}