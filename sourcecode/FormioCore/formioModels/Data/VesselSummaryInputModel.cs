using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class VesselSummaryInputModel
    {
        public Guid? Id { get; set; }
        public string UniqueId { get; set; }
        public string ProductGroup { get; set; }
        public decimal? RealisedTotal { get; set; }
        public decimal? UnRealisedTotal { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid CompanyId { get; set; }
        public bool? IsArchived { get; set; }
    }

    public class RefreshVesselSummaryInputModel
    {
        public string UniqueId { get; set; }
        public string ProductGroup { get; set; }
        public string CompanyName { get; set; }
        public decimal? RealisedTotal { get; set; }
        public decimal? UnRealisedTotal { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool IsInstanceLevelRefresh { get; set; }
    }

    public class VesselModel
    {
        public string UniqueId { get; set; }
        public string Locaton { get; set; }
        public bool IsImportId { get; set; }
    }

    public class UniqueValidateModel
    {
        public string DataJson { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? FormId { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
    }
}
