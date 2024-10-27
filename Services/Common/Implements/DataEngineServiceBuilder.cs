using MarketExample.Services.Common.Contracts;

namespace MarketExample.Services.Common.Implements
{
    public class DataEngineServiceBuilder : IDataEngineServiceBuilder
    {
        private readonly IServiceProvider _serviceProvider;
        public DataEngineServiceBuilder(IServiceProvider services)
        {
            _serviceProvider = services;
        }

        public IDataEngineService GetDalService<IAgentDbConnection>()
        {
            Type classType = typeof(IAgentDbConnection);
            object instance = Activator.CreateInstance(classType);
            if (instance is IAgentDbConnection obj)
            {
                return new SqlDataEngineService(_serviceProvider, obj.ToString());
            }
            return null;
        }
    }
}