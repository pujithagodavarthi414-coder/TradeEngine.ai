using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Bson.Serialization;
using MongoDB.Driver;

namespace DocumentStorageService.Repositories.Helpers
{
    public class BsonHelper
    {
        public static AggregateOptions GetAggregateOptionsObject()
        {
            return new AggregateOptions() { AllowDiskUse = true };
        }

        public static BsonDocument GetBsonLookupObject(string from, string localField, string foreignField, string alias)
        {
            return new BsonDocument("$lookup",
                new BsonDocument
                {
                    { "from", from },
                    { "localField", localField },
                    { "foreignField", foreignField },
                    { "as", alias }
                });
        }

        public static BsonDocument GetBsonUnwindObject(string alias)
        {
            return new BsonDocument("$unwind",
                new BsonDocument("path", $"${alias}"));
        }

        public static BsonDocument GetBsonKeyValueObject(string key, dynamic value)
        {
            return new BsonDocument(key, value);
        }

        public static BsonElement GetBsonElementObject(string name, dynamic value)
        {
            return new BsonElement(name, value);
        }

        public static BsonDocument GetBsonElementMatchObject(IDictionary<string, dynamic> elementMatch, string documentArray)
        {
            BsonDocument cond = new BsonDocument();

            foreach (var kvp in elementMatch)
            {
                cond.Add(kvp.Key, kvp.Value);
            }

            return new BsonDocument(documentArray, new BsonDocument("$elemMatch", cond));
        }

        public static BsonDocument GetBsonConditionalOperationObject(string operation, List<BsonDocument> conditions)
        {
            return new BsonDocument(operation, new BsonArray(conditions));
        }

        public static BsonDocument GetBsonConditionalOperationObject(string operation, BsonElement condition)
        {
            return new BsonDocument(operation, new BsonArray { condition.Name, condition.Value });
        }

        public static BsonDocument GetBsonFilterObject(string input, string alias, BsonDocument condition)
        {
            return new BsonDocument("$filter", new BsonDocument
            {
                { "input", input },
                { "as", alias },
                { "cond", condition}
            });
        }

        public static BsonDocument GetAddFieldsObject(string fieldName, dynamic value)
        {
            return new BsonDocument("$addFields", new BsonDocument(fieldName, value));
        }

        public static BsonDocument GetBsonDocumentObject(List<BsonElement> bsonElements)
        {
            return new BsonDocument(bsonElements);
        }

        public static BsonDocument GetBsonPushArrayOfObjects(string Key, List<BsonDocument> items)
        {
            return new BsonDocument("$push", new BsonDocument(Key, new BsonDocument("$each", new BsonArray(items))));
        }

        public static List<T> ConvertBsonDocumentListToModel<T>(List<BsonDocument> documents)
        {
            List<T> models = new List<T>();

            try
            {
                Parallel.ForEach(documents, d =>
                {
                    models.Add(BsonSerializer.Deserialize<T>(d));
                });
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception.Message);
            }

            return models;
        }

        public static BsonDocument ConvertElementsListToDocument(List<BsonElement> elements)
        {
            return new BsonDocument(elements);
        }

        public static BsonArray ConvertGenericListToBsonArray<T>(List<T> items)
        {
            return new BsonArray(items);
        }

        public static BsonDocument GetBsonDocumentWithConditionalObject<T>(string operation, List<T> items)
        {
            return new BsonDocument(operation, ConvertGenericListToBsonArray(items));
        }


    }

}
