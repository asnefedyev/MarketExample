using Microsoft.Extensions.ObjectPool;
using Microsoft.Data.SqlClient;
using MarketExample.Services.Common.Contracts;
using MarketExample.Services.Common.Implements.SqlDbConnectionFactories;

namespace MarketExample.Services.Common.Implements
{
    public class SqlDbConnectionFactory : IDbConnectionFactory
    {
        private readonly ObjectPool<SqlConnection> _connectionPool;

        public SqlDbConnectionFactory(IConfiguration configuration, ObjectPoolProvider poolProvider, string connectionAlias)
        {
            _connectionPool = poolProvider.Create(new SqlConnectionPoolPolicy(configuration, connectionAlias));
        }

        public SqlConnection CreateConnection()
        {
            return _connectionPool.Get();
        }
    }
}
