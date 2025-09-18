using Microsoft.Extensions.Configuration;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioRepo.Base
{
    public abstract class BaseMongoConnection
    {
        public BaseMongoConnection(IConfiguration configuration)
        {
            iconfiguration = configuration;
        }

        public IConfiguration iconfiguration { get; }
        public IMongoDatabase GetMongoDbConnection()
        {
            MongoClient client = new MongoClient(iconfiguration["MongoDBConnectionString"]);
            return client.GetDatabase(iconfiguration["MongoCommunicatorDB"]);
        }
        public IMongoCollection<T> GetMongoCollectionObject<T>(string collectionName)
        {
            IMongoDatabase imongoDb = GetMongoDbConnection();
            return imongoDb.GetCollection<T>(collectionName);
        }
    }
}
