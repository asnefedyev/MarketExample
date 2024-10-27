using Microsoft.EntityFrameworkCore;
using System.Data;

namespace MarketExample.Services.Common.Contracts
{
    public interface IDataEngineService : IDatabaseDiagnostic
    {
        public List<TEntity> GetEntityList<TEntity>(Func<IDbConnection, List<TEntity>> processing) where TEntity : class;
        public void ChangeEntityList(Action<IDbConnection> processing);
        public List<TEntity> GetEntityList<TEntity>(Func<DbContext, List<TEntity>> processing) where TEntity : class;
        public void ChangeEntityList(Action<DbContext> processing);
    }
}