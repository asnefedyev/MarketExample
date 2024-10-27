using System.Data;
using MarketExample.Services.Common.Contracts;
using MarketExample.Services.Common.SqlConnections;

namespace MarketExample.Services.Common.Implements
{
    public class SqlDatabaseConnection : IDatabaseConnection
    {
        private readonly ISqlDbConnectionFactoryBuilder _builderFactory;

        public SqlDatabaseConnection(ISqlDbConnectionFactoryBuilder builderFactory)
        {
            _builderFactory = builderFactory;
        }

        public IDbConnection GetDbConnection(string alias)
        {
            return _builderFactory.GetConnectionFactory(alias).CreateConnection();
        }

        public IDbConnection GetDbConnection()
        {
            return _builderFactory
                .GetConnectionFactory(new DefaultConnection().ToString())
                .CreateConnection();
        }
    }
}