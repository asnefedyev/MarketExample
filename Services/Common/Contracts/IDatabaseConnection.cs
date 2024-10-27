using System.Data;

namespace MarketExample.Services.Common.Contracts
{
    public interface IDatabaseConnection
    {
        IDbConnection GetDbConnection();
        IDbConnection GetDbConnection(string alias);

        public string ToString()
        {
            return "some connection settings";
        }
    }
}