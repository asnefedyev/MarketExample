using Microsoft.Data.SqlClient;

namespace MarketExample.Services.Common.Contracts
{
    public interface IDbConnectionFactory
    {
        SqlConnection CreateConnection();
    }
}
