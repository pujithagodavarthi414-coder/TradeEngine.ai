using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Bson.Serialization;

namespace PDFHTMLDesignerRepo.Helpers
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
    }
}
