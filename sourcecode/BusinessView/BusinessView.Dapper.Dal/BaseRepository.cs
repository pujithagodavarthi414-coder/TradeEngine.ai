using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Dapper;

namespace Btrak.Dapper.Dal
{
    public abstract class BaseRepository
    {
        protected static void SetIdentity<T>(IDbConnection connection, Action<T> setId)
        {
            dynamic identity = connection.Query("SELECT @@IDENTITY AS Id").Single();
            T newId = (T)identity.Id;
            setId(newId);
        }
        protected static IDbConnection OpenConnection()
        {
            IDbConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString);
            connection.Open();
            return connection;
        }

        protected static IDbConnection OpenAuthConnection()
        {
            IDbConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["AuthenticationConnectionString"].ConnectionString);
            connection.Open();
            return connection;
        }

        protected static IDbConnection OpenCamundaSqlConnection(string connectionString)
        {
            IDbConnection connection = new SqlConnection(connectionString);
            connection.Open();
            return connection;
        }

    }
}
