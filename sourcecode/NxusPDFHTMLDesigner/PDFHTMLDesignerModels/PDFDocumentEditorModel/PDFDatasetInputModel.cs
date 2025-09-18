using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.DocumentModel
{
        public class Child
        {
            public int id { get; set; }
            public string subMenuId { get; set; }
            public string name { get; set; }
            public string subMenuName { get; set; }
            public string description { get; set; }
        }

    [BsonIgnoreExtraElements]
    public class PDFDatasetInputModel
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string _id { get; set; }
        public int id { get; set; }
        public Guid? form { get; set; }
        public string form_Name { get; set; }
        public string htmlAttributes { get; set; }
        public List<Child> child { get; set; }
    }
 }
