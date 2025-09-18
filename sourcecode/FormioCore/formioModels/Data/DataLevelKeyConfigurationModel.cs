using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class DataLevelKeyConfigurationModel
    {
        public Guid? Id { get; set; }
        public string Level { get; set; }
        public string LevelName { get; set; }
        public Guid? PdfTemplate { get; set; }
        public string DisplayName { get; set; }
        public string Path { get; set; }
        public string ApiKey { get; set; }
        public string Parameters { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public bool? IsArchived { get; set; }
    }
    public class UpsertDataLevelKeyConfigurationModel
    {
        public Guid? Id { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public BsonDocument DataJson { get; set; }
        public bool? IsArchived { get; set; }
    }
    public class GetDataLevelKeyConfigurationModel
    {
        public Guid? Id { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public object DataJson { get; set; }
        public bool? IsArchived { get; set; }
    }
}
