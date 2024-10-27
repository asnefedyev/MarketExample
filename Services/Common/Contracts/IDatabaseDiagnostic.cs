namespace MarketExample.Services.Common.Contracts
{
    public interface IDatabaseDiagnostic
    {
        public bool IsDataBaseAvailability();
        string GetDbSessionId();
    }
}
