using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.DocumentOutputModel
{
    [BsonIgnoreExtraElements]
    public class PDFDatasetOutputModel
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string _id { get; set; }
        public int fid { get; set; }
        public string form { get; set; }
        public string form_Name { get; set; }
        public string htmlAttributes { get; set; }

        [BsonElement("child")]
        [JsonPropertyName("child")]
        public List<Child> child { get; set; } = null!;
    }

    [BsonIgnoreExtraElements]
    public class Child
    {
        public int cid { get; set; }
        public string subMenuId { get; set; }
        public string name { get; set; }
        public string subMenuName { get; set; }
        public string description { get; set; }
    }
}
