using System;
using System.Collections.Generic;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class DataSetOutputModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public object DataJson { get; set; }
        public object DataJsonForFields { get; set; }
        public object ContractData { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public int? TotalCount { get; set; }
        public object ContractJson { get; set; }
        public List<DataSetOutputModel> PurchaseContracts { get; set; }
        public List<DataSetOutputModel> SalesContracts { get; set; }
        public Guid? ProgramId { get; set; }
        public object ProgramFormData { get; set; }
        public Guid? VesselContractId { get; set; }
    }

    public class DataSetOutputReturnModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public object DataJson { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string CreatedDate { get; set; }
        public object ContractJson { get; set; }
    }

    public class UserDatasetRelationOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }
        public List<Guid> DataSetIds { get; set; }
        public Guid? CompanyId { get; set; }

        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
    }
    public class DataSetOutputModelForFormFields
    {
        public object Data { get; set; }
        public int? TotalCount {get; set;}
    }
}
