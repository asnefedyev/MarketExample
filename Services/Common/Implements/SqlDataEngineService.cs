using System.Data;
using Microsoft.EntityFrameworkCore;
using MarketExample.Services.Common.Contracts;
using MarketExample.Services.Common.Implements.Contexts;

namespace MarketExample.Services.Common.Implements
{
    public class SqlDataEngineService : IDataEngineService
    {
        private readonly IServiceProvider _sp;
        private readonly IDatabaseConnection _Connection;
        private readonly string _dbAlias;

        public SqlDataEngineService(IServiceProvider sp, string dbAlias)
        {
            _sp = sp;
            _Connection = (IDatabaseConnection?)sp.GetService(typeof(IDatabaseConnection));
        }

        public List<TEntity> GetEntityList<TEntity>(Func<IDbConnection, List<TEntity>> processing) where TEntity : class
        {
            List<TEntity> lst;
            using (IDbConnection connection = _Connection.GetDbConnection())
            {
                lst = processing(connection);
            }
            return lst;
        }

        public void ChangeEntityList(Action<IDbConnection> processing)
        {
            using (IDbConnection connection = _Connection.GetDbConnection())
            {
                processing(connection);
            }
        }

        internal ExampleDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<ExampleDbContext>()
                .UseSqlServer(_Connection.GetDbConnection().ConnectionString, options =>
                    options.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null))
                .Options;
            var context = new ExampleDbContext(options);
            return context;
        }

        public List<TEntity> GetEntityList<TEntity>(Func<DbContext, List<TEntity>> processing) where TEntity : class
        {
            List<TEntity> prev;
            using (DbContext context = GetDbContext())
            {
                var strategy = context.Database.CreateExecutionStrategy();
                return strategy.Execute(() =>
                {
                    using (var transaction = context.Database.BeginTransaction())
                    {
                        try
                        {
                            var result = processing(context);
                            prev = result;
                            transaction.Commit();
                            return prev;
                        }
                        catch (Exception)
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                });
            }
        }

        public void ChangeEntityList(Action<DbContext> processing)
        {
            using (DbContext context = GetDbContext())
            {
                var strategy = context.Database.CreateExecutionStrategy();
                strategy.Execute(() =>
                {
                    using (var transaction = context.Database.BeginTransaction())
                    {
                        try
                        {
                            processing(context);
                            transaction.Commit();
                        }
                        catch (Exception)
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                });
            }
        }

        public bool IsDataBaseAvailability()
        {
            throw new NotImplementedException();
        }

        public string GetDbSessionId()
        {
            throw new NotImplementedException();
        }
    }
}