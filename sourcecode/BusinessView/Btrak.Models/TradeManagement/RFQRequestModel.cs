using System;
using System.Collections.Generic;

namespace Btrak.Models.TradeManagement
{
    public class RFQRequestModel
    {
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? TemplateId { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public string DataJson { get; set; }
        public List<Guid> ClientId { get; set; }
        public List<Guid> BrokerId { get; set; }
        public Guid? StatusId { get; set; }
        public int? Version { get; set; }
        public string ClientIdXml { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
    }

    public class RFQRequestInputModel
    {
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? TemplateId { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public Guid? VesselConfirmationTemplateId { get; set; }
        public string DataJson { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? VesselConfirmationStatusId { get; set; }
        public int? Version { get; set; }
        public int? RFQId { get; set; }
        public bool? IsAccepted { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsRejected { get; set; }
        public bool? IsVesselConfirmationChange { get; set; }
        public string VesselConfirmationFormData { get; set; }
        public bool? IsRequestVesselConfirmation { get; set; }
        public string RejectedComments { get; set; }
        public string SendBackComments { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
    }

    public class ShareQ88InputModel 
    {
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public int? RFQId { get; set; }
        public List<Guid> BankerId { get; set; }
        public List<Guid> BuyerId { get; set; }
        public List<Guid> SellerId { get; set; }
    }

    public class UpdateQ88InputModel
    {
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public int? RFQId { get; set; }
        public bool? IsAccepted { get; set; }
        public bool? IsRejected { get; set; }
        public string RejectedComments { get; set; }
    }

}
