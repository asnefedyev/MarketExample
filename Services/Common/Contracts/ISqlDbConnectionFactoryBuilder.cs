namespace MarketExample.Services.Common.Contracts
{
    public interface ISqlDbConnectionFactoryBuilder
    {
        public IDbConnectionFactory GetConnectionFactory(string alias);
    }
}