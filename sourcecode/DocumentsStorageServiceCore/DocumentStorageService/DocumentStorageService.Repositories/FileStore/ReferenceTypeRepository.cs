using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using Microsoft.Extensions.Configuration;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Text;

namespace DocumentStorageService.Repositories.FileStore
{
    public class ReferenceTypeRepository
    {
        IConfiguration _iconfiguration;
        public ReferenceTypeRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }
        public List<ReferenceTypeReturnModel> SearchReferenceType(ReferenceTypeSearchInputModel referenceTypeSearchCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchReferenceType", "ReferenceTypeRepository"));

                IMongoCollection<ReferenceTypeReturnModel> referenceTypeCollections = GetMongoCollectionObject<ReferenceTypeReturnModel>(MongoDBCollectionConstants.ReferenceTypeCollection);

                var fBuilder = Builders<ReferenceTypeReturnModel>.Filter;
                var filters = new List<FilterDefinition<ReferenceTypeReturnModel>>();
                List<ReferenceTypeReturnModel> filteredResult = new List<ReferenceTypeReturnModel>();

                if (referenceTypeSearchCriteriaInput.ReferenceTypeId != null)
                {
                    filters.Add(fBuilder.Eq("_id", referenceTypeSearchCriteriaInput.ReferenceTypeId.ToString().ToUpper()));
                }

                if (referenceTypeSearchCriteriaInput.ReferenceTypeName != null)
                {
                    filters.Add(fBuilder.Eq("ReferenceTypeName", referenceTypeSearchCriteriaInput.ReferenceTypeName.ToString()));
                }

                var filterObject = fBuilder.And(filters);
                filteredResult = referenceTypeCollections.Find(filterObject).ToList();

                return filteredResult;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchReferenceType", "ReferenceTypeRepository", exception.Message), exception);
                return null;
            }
        }

        protected IMongoDatabase GetMongoDbConnection()
        {
            MongoClient client = new MongoClient(_iconfiguration["MongoDBConnectionString"]);
            return client.GetDatabase(_iconfiguration["MongoCommunicatorDB"]);
        }
        protected IMongoCollection<T> GetMongoCollectionObject<T>(string collectionName)
        {
            IMongoDatabase imongoDb = GetMongoDbConnection();
            return imongoDb.GetCollection<T>(collectionName);
        }
    }
}
