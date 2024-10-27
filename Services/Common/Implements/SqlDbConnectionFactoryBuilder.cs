using Microsoft.Extensions.ObjectPool;
using MarketExample.Services.Common.Contracts;

namespace MarketExample.Services.Common.Implements
{
    public class SqlDbConnectionFactoryBuilder : ISqlDbConnectionFactoryBuilder
    {
        private readonly IConfiguration _configuration;
        private readonly ObjectPoolProvider _poolProvider;

        public SqlDbConnectionFactoryBuilder(IConfiguration configuration, ObjectPoolProvider poolProvider)
        {
            _configuration = configuration;
            _poolProvider = poolProvider;
        }

        public IDbConnectionFactory GetConnectionFactory(string alias)
        {
            return new SqlDbConnectionFactory(_configuration, _poolProvider, alias);
        }
    }
}