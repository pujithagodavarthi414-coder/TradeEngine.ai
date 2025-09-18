using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace AuthenticationServices.Repositories.Repositories
{
    public class BaseRepository
    {
        IConfiguration _iconfiguration;

        public BaseRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }

        protected IDbConnection OpenConnection()
        {
            IDbConnection connection = new SqlConnection(_iconfiguration.GetConnectionString("BTrakConnectionString"));
            connection.Open();
            return connection;
        }
    }
}
