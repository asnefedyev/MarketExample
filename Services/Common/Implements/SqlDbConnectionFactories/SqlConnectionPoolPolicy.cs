using Microsoft.Data.SqlClient;
using Microsoft.Extensions.ObjectPool;

namespace MarketExample.Services.Common.Implements.SqlDbConnectionFactories
{
    public class SqlConnectionPoolPolicy : IPooledObjectPolicy<SqlConnection>
    {
        private readonly string _connectionString;

        public SqlConnectionPoolPolicy(IConfiguration configuration, string connectionAlias)
        {
            _connectionString = configuration.GetConnectionString(connectionAlias);
        }

        public SqlConnection Create()
        {
            return new SqlConnection(_connectionString);
        }

        public bool Return(SqlConnection obj)
        {
            return true;
        }
    }
}