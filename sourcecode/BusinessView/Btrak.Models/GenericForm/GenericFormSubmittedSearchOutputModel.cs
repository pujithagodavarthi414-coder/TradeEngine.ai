using System;

namespace Btrak.Models.GenericForm
{
    public class GenericFormSubmittedSearchOutputModel
    {
        public Guid? GenericFormSubmittedId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public string FormJson { get; set; }
        public string DataJson { get; set; }
        public string WorkflowTrigger { get; set; }
        public Guid? FormId { get; set; }
        public bool? IsPdfGenerated { get; set; }
        public string UniqueNumber { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public string FormSrc { get; set; }
        public string FormName { get; set; }
        public string KeyValue { get; set; }
        public bool? IsAbleToLogin { get; set; }
        public bool? IsAbleToPay { get; set; }
        public bool? IsAbleToCall { get; set; }
        public bool? IsAbleToComment { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsApproveNeeded { get; set; }
        public int? TotalCount { get; set; }
        public string Status { get; set; }
        public string Stage { get; set; }
    }
}
