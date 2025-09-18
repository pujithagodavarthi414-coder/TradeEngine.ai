using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Bson.IO;
using MongoDB.Bson.Serialization;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace formioRepo.Helpers
{
    public class BsonHelper
    {
        public static List<T> ConvertBsonDocumentListToModel<T>(List<BsonDocument> documents)
        {
            List<T> models = new List<T>();

            try
            {
                foreach(var d in documents)
                {
                    models.Add(BsonSerializer.Deserialize<T>(d));
                }
               
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception.Message);
            }

            return models;
        }
        public static BsonDocument GetBsonDocumentWithConditionalObject<T>(string operation, List<T> items)
        {
            return new BsonDocument(operation, ConvertGenericListToBsonArray(items));
        }

        public static BsonDocument GetBsonDocumentWithJoin<T>(string from, string localField, string foreignField,
            string alias)
        {
            return new BsonDocument("$lookup", new BsonDocument {
                {"from", from},
                {"localField", localField},
                {"foreignField", foreignField},
                {"as", alias}
            });
        }
        public static BsonArray ConvertGenericListToBsonArray<T>(List<T> items)
        {
            return new BsonArray(items);
        }

        public static string ConvertBsonDocumentsToJson(IEnumerable<BsonDocument> bsonDocuments)
        {
            var jArray = new JArray();

            foreach (var bsonDocument in bsonDocuments)
            {
                var jsonString = bsonDocument.ToJson(new JsonWriterSettings { OutputMode = JsonOutputMode.Strict });

                var jObject = JObject.Parse(jsonString);
                ConvertSpecialDataTypes(jObject);

                jArray.Add(jObject);
            }

            return jArray.ToString();
        }

        private static void ConvertSpecialDataTypes(JToken token)
        {
            if (token.Type == JTokenType.Object)
            {
                var obj = (JObject)token;
                foreach (var property in obj.Properties())
                {
                    if (property.Value.Type == JTokenType.String && property.Value.ToString().StartsWith("ISODate("))
                    {
                        var dateString = property.Value.ToString();
                        var isoDateString = dateString.Substring(9, dateString.Length - 10);
                        var isoDate = DateTime.Parse(isoDateString);
                        property.Value = isoDate;
                    }
                    else if (property.Value.Type == JTokenType.String && property.Value.ToString().StartsWith("NumberLong("))
                    {
                        var numberString = property.Value.ToString();
                        var numberValue = long.Parse(numberString.Substring(11, numberString.Length - 12));
                        property.Value = numberValue;
                    }
                    else
                    {
                        ConvertSpecialDataTypes(property.Value);
                    }
                }
            }
            else if (token.Type == JTokenType.Array)
            {
                var array = (JArray)token;
                foreach (var item in array)
                {
                    ConvertSpecialDataTypes(item);
                }
            }
        }
    }
}
