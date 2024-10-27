using MarketExample.Services.Common.Contracts;

namespace MarketExample.Services.Common.SqlConnections
{
    public class DefaultConnection : IAgentDbConnection
    {
        public override string ToString()
        {
            return "DefaultConnection";
        }
    }
}