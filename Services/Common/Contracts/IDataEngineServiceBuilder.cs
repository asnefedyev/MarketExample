namespace MarketExample.Services.Common.Contracts
{
    public interface IDataEngineServiceBuilder
    {
        public IDataEngineService GetDalService<IConfigDbConnection>();
    }
}