using Btrak.Models.FormDataServices;
using Btrak.Models.GenericForm;
using Btrak.Models.TradeManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class DataSetOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public DataSetConversionModel DataJson { get; set; }
        public object DataJsonForFields { get; set; }
        public ContractModel ContractData { get; set; }
        public string Name { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public int? TotalCount { get; set; }
        public DataSetConversionModel ContractJson { get; set; }
        public List<DataSetOutputModel> PurchaseContracts { get; set; }
        public List<DataSetOutputModel> SalesContracts { get; set; }
        public Guid? VesselContractId { get; set; }

    }

    public class DataSetOutputModelForWorkflows
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public WorkflowModel DataJson { get; set; }
        public object DataJsonForFields { get; set; }
        public ContractModel ContractData { get; set; }
        public string Name { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public int? TotalCount { get; set; }
        public DataSetConversionModel ContractJson { get; set; }
        public List<DataSetOutputModel> PurchaseContracts { get; set; }
        public List<DataSetOutputModel> SalesContracts { get; set; }
        public Guid? VesselContractId { get; set; }

    }

    public class DataSetOutputModelForForms
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public DataSetConversionModel DataJson { get; set; }
        public ContractModel ContractData { get; set; }
        public string Name { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsPdfGenerated { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public int? TotalCount { get; set; }
        public DataSetConversionModel ContractJson { get; set; }
        public List<DataSetOutputModel> PurchaseContracts { get; set; }
        public List<DataSetOutputModel> SalesContracts { get; set; }
        public Guid? VesselContractId { get; set; }
        public bool? IsApproved { get; set; }

    }


}
