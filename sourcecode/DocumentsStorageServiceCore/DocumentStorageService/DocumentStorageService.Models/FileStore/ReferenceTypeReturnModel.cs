using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    [BsonIgnoreExtraElements]
    public class ReferenceTypeReturnModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public string ReferenceTypeName { get; set; }
    }
}
