using System;
using System.Collections.Generic;
using BTrak.Common;

namespace Btrak.Models.TradeManagement
{
    public class SwitchBlContractModel : SearchCriteriaInputModelBase
    {
        public SwitchBlContractModel() : base(InputTypeGuidConstants.ContractModelInputCommandTypeGuid)
        {
        }
        public Guid? ContractTemplateId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? VesselId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public object FormData { get; set; }
        public object OldData { get; set; }
        public object NewData { get; set; }
        public bool? IsPagingRequired { get; set; }
        public bool? IsObjectChanged { get; set; }
        public List<ParamsJsonModel> ParamsJson { get; set; }
        public int? VesselQuantity { get; set; }
        public bool IsShareSwitchBlContract { get; set; }
        public bool IsSwitchBl { get; set; }
        public List<SwitchBlDetailsModel> SwitchBlDetails { get; set; }
        public List<PurchaseContractDraftBlDetails> PurchaseBlDetails { get; set; }
        public List<ContractModel> PurchaseContracts { get; set; }
        public List<ContractModel> SalesContracts { get; set; }
        public DateTime? ContractSealedDateTime { get; set; }
        public string AcceptComment { get; set; }
        public string RejectComment { get; set; }
        public bool? IsAccepted { get; set; }
        public bool? IsVesselOwnerAccepted { get; set; }
        public bool? IsContractSharedToVesselOwner { get; set; }
        public Guid? SelectedClientId { get; set; }
        public Guid? VesselOwnerId { get; set; }
        public bool? IsSwitchBlReinitiated { get; set; }
        public Guid? SelectedSaleContractId { get; set; }
        public Guid? SaleContractId { get; set; }
        public string StatusName { get; set; }
        public List<Guid?> SaleContractIds { get; set; }
        public string BuyerAcceptComment { get; set; }
        public string BuyerRejectComment { get; set; }
        public string VesselOwnerAcceptComment { get; set; }
        public string VesselOwnerRejectComment { get; set; }
    }

    public class SwitchBlDetailsModel
    {
        public Guid? ClientId { get; set; }
        public string ActionType { get; set; }
        public bool IsQuantitySplited { get; set; }
        public bool IsRequiredQuantity { get; set; }
        public PurchaseContractDetails PurchaseContractDetails { get; set; }
        public List<PurchaseContractDetails> PurchaseContractDetailsList { get; set; }
        public List<SplitBlModel> SplitList { get; set; }
        public string DraftBlNumber { get; set; }
        public string VesselBlNumber { get; set; }
        public string Master { get; set; }
        public string OceanCarriageStowage { get; set; }
        public string Consignee { get; set; }
        public string Consigner { get; set; }
        public string NotifyParty { get; set; }
        public float? Quantity { get; set; }
        public bool? IsSwitchBlBuyerContractAccepted { get; set; }
        public bool? IsSwitchBlBuyerContractRejected { get; set; }
        public bool? IsSwitchBlVesselOwnerAccepted { get; set; }
        public bool? IsSwitchBlVesselOwnerRejected { get; set; }
        public bool? IsShareSwitchBlContract { get; set; }
        public Guid? SaleContractId { get; set; }
    }
    public class PurchaseContractDetails
    {
        public Guid? PurchaseContractId { get; set; }
        public Guid? SaleContractId { get; set; }
        public Guid? PurchaseBlId { get; set; }
        public float? Quantity { get; set; }
        public string DraftBlNumber { get; set; }
        public string VesselBlNumber { get; set; }
        public string Master { get; set; }
        public string OceanCarriageStowage { get; set; }
        public bool? IsSwitchBlBuyerContractAccepted { get; set; }
        public bool? IsSwitchBlBuyerContractRejected { get; set; }
        public bool? IsSwitchBlVesselOwnerAccepted { get; set; }
        public bool? IsSwitchBlVesselOwnerRejected { get; set; }
        public string Consignee { get; set; }
        public string Consigner { get; set; }
        public string NotifyParty { get; set; }
    }

    public class SplitBlModel
    {
        public float? Quantity { get; set; }
        public string DraftBlNumber { get; set; }
        public string VesselBlNumber { get; set; }
        public string Master { get; set; }
        public string OceanCarriageStowage { get; set; }
        public bool? IsSwitchBlBuyerContractAccepted { get; set; }
        public bool? IsSwitchBlBuyerContractRejected { get; set; }
        public bool? IsSwitchBlVesselOwnerAccepted { get; set; }
        public bool? IsSwitchBlVesselOwnerRejected { get; set; }
        public string Consignee { get; set; }
        public string Consigner { get; set; }
        public string NotifyParty { get; set; }
    }

    public class SwitchBlBuyerContractOutputModel
    {
        public float? Quantity { get; set; }
        public List<BuyerSwitchBlContractDetails> BuyerSwitchBlContractDetails { get; set; }
        public SwitchBlContractModel  SgTraderSwitchBlContractDetails{ get; set; }
    }
    public class BuyerSwitchBlContractDetails
    {
        public Guid Id { get; set; }
        public Guid? PurchaseBlId { get; set; }
        public List<Guid?> PurchaseBlIdList { get; set; }
        public float? Quantity { get; set; }
        public string BlNumber { get; set; }
        public string Consignee { get; set; }
        public string Consigner { get; set; }
        public string NotifyParty { get; set; }
        public string ContractUrl { get; set; }
        public string VesselBlNumber { get; set; }
        public string Master { get; set; }
        public string OceanCarriageStowage { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public bool? IsShareSwitchBlContract { get; set; }
        public bool? IsSwitchBlBuyerContractAccepted { get; set; }
        public bool? IsSwitchBlBuyerContractRejected { get; set; }
        public bool? IsSwitchBlVesselOwnerAccepted { get; set; }
        public bool? IsSwitchBlVesselOwnerRejected { get; set; }
        public string BuyerAcceptComment { get; set; }
        public string BuyerRejectComment { get; set; }
        public string VesselOwnerAcceptComment { get; set; }
        public string VesselOwnerRejectComment { get; set; }
        public string StatusName { get; set; }
    }

    public class SwitchBlBuyerContractInputModel : SearchCriteriaInputModelBase
    {
        public SwitchBlBuyerContractInputModel() : base(InputTypeGuidConstants.ContractModelInputCommandTypeGuid)
        {
        }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSetId { get; set; }
        public object FormData { get; set; }
        public bool? IsPagingRequired { get; set; }
        public List<ParamsJsonModel> ParamsJson { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? SaleContractId { get; set; }
        public Guid? ContractId { get; set; }
    }
    public class FinalSwitchBlModel
    {
        public Guid? DataSourceId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? VesselId { get; set; }
        public bool IsShareSwitchBlContract { get; set; }
        public List<SwitchBlDetailsModel> SwitchBlDetails { get; set; }
        public Guid? VesselOwnerId { get; set; }
        public Guid? SaleContractId { get; set; }
        public string StatusName { get; set; }
        public string BuyerAcceptComment { get; set; }
        public string BuyerRejectComment { get; set; }
        public string VesselOwnerAcceptComment { get; set; }
        public string VesselOwnerRejectComment { get; set; }
    }

}
