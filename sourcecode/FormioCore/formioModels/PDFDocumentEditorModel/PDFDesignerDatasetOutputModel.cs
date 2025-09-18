using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.PDFDocumentEditorModel
{
    [BsonIgnoreExtraElements]
    public class PDFDesignerDatasetOutputModel
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string _id { get; set; }
        public string MongoResult { get; set; }
        public string DataSource { get; set; }
        public string MongoQuery { get; set; }
        public DataSorceParams[] MongoParamsType { get; set; }
        public DataSourceDummyParamValues[] MongoDummyParams { get; set; }
    }
}
