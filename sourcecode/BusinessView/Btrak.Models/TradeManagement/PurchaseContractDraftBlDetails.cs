using System;
using System.Collections.Generic;

namespace Btrak.Models.TradeManagement
{
    public class PurchaseContractDraftBlDetails
    {
        public Guid? ContractId { get; set;}
        public Guid? PurchaseId { get; set;}
        public Guid? DataSourceId { get; set; }
        public object FormData { get; set;}
        public object FormJson { get; set;}   
        public string StatusName { get; set;}
        public object DataSourceFormJson { get; set;}
        public List<DraftBlDetails> BlDetails { get; set;}
    }
    public class DraftBlDetails
    {
        public Guid? Id { get; set; }
        public Guid? PurchaseId { get; set; }
        public string BlNumber { get; set; }
        public float? TotalQuantity { get; set; }
        public int? RemainingQuantity { get; set; }
        public string Consignee { get; set; }
        public string Consigner { get; set; }
        public string NotifyParty { get; set; }
        public string ContractUrl { get; set; }
        public DateTime BlDate { get; set; }
        public Guid? PortOfLoading { get; set; }
        public Guid? PortOfLoadingCountry { get; set; }
        public Guid? PortOfDischarge { get; set; }
        public Guid? PortOfDischargeCountry { get; set; }
        public string PortOfLoadingName { get; set; }
        public string PortOfLoadingCountryName { get; set; }
        public string PortOfDischargeName { get; set; }
        public string PortOfDischargeCountryName { get; set; }
        public string ReUploadedUrl { get; set; }
        public bool? IsFileReUploaded { get; set; }
    }
}
