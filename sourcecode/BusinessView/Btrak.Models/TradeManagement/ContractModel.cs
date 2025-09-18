using Btrak.Models.FormDataServices;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class ContractModel : SearchCriteriaInputModelBase
    {
        public ContractModel() : base(InputTypeGuidConstants.ContractModelInputCommandTypeGuid)
        {
        }
        public Guid? ContractTemplateId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSetId { get; set; }
        public bool IsAtLinkedContractEdit { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? VesselConfirmationStatusId { get; set; }
        public Guid? VesselConfirmationTemplateId { get; set; }
        public Guid? BrokerId { get; set; }
        public bool IsShareDraft { get; set; }
        public bool IsForSales { get; set; }
        public bool IsSelectPercentage { get; set; }
        public bool IsSelectValue { get; set; }
        public bool IsSelectCommodityBroker { get; set; }
        public bool IsDraftRejected { get; set; }
        public bool IsDraftAccepted { get; set; }
        public bool IsSGTraderSignatureVerificationNeed { get; set; }
        public bool IsSellerSignatureVerificationNeed { get; set; }
        public bool IsSellerSignatureDone { get; set; }
        public bool IsSgTraderSignatureDone { get; set; }
        public int BrokeragePercentage { get; set; }
        public int BrokerageValue { get; set; }
        public string StatusName { get; set; }
        public string StatusColor { get; set; }
        public string ContractType { get; set; }
        public string InvoicePdfUrl { get; set; }
        public string InvoiceType { get; set; }
        public string ContractPdf { get; set; }
        public string SellerSignatureRejectedComments { get; set; }
        public string SellerSignatureAcceptedComments { get; set; }
        public string SgtraderSignatureRejectedComments { get; set; }
        public string SgtraderSignatureAcceptedComments { get; set; }
        public string SgtraderInvoiceAcceptedComments { get; set; }
        public string SgtraderInvoiceRejectedComments { get; set; }
        public string ContracterInvoiceAcceptedComments { get; set; }
        public string ContracterInvoiceRejectedComments { get; set; }
        public string DraftRejectComments { get; set; }
        public string DraftAcceptComments { get; set; }
        public object FormData { get; set; }
        public string TemplateData { get; set; }
        public ContractModel ContractData { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? LinkCreatedDateTime { get; set; }
        public DateTime? ApprovedDate { get; set; }
        public DateTime? PaidDate { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string UpdatedByUserName { get; set; }
        public string CreatedByUserName { get; set; }
        public int TotalCount { get; set; }
        public object Fields { get; set; }
        public bool? IsPagingRequired { get; set; }
        public List<ParamsJsonModel> ParamsJson { get; set; }
        public string ListType { get; set; }
        public Guid? ReferenceId { get; set; }
        public string ReferenceUserName { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public int? Version { get; set; }
        public int? RFQId { get; set; }
        public string RFQUniqueId { get; set; }
        public Guid? AcceptedByClientUserId { get; set; }
        public Guid? AcceptedByTraderUserId { get; set; }
        public bool? IsAccepted { get; set; }
        public bool? IsRejected { get; set; }
        public bool? IsVesselConfirmationAccepted { get; set; }
        public bool? IsVesselConfirmationRejected { get; set; }
        public bool IsSellerSignatureAccepted { get; set; }
        public bool IsSellerSignatureRejected { get; set; }
        public bool IsSGTraderSignatureAccepted { get; set; }
        public bool IsSGTraderSignatureRejected { get; set; }
        public bool IsContractSealing { get; set; }
        public string ClientName { get; set; }
        public string BrokerName { get; set; }
        public object InvoiceId { get; set; }
        public List<Guid> Q88SharedClientIds { get; set; }
        public List<Guid> Q88SharedUserIds { get; set; }
        public List<Guid> Q88AcceptedIds { get; set; }
        public List<Guid> Q88RejectedIds { get; set; }
        public DateTime? RFQAcceptedDateTime { get; set; }
        public DateTime? RFQRejectedDateTime { get; set; }
        public List<Q88RejectedModel> Q88Reject { get; set; }
        public bool? IsQ88Accepted { get; set; }
        public bool IsQ88Uploaded { get; set; }
        public bool? IsLinking { get; set; }

        public bool? IsCreateLinkContract { get; set; }

        public bool? IsContractLink { get; set; }
        public List<Guid> PurchaseContractIds { get; set; }
        public List<Guid> SalesContractIds { get; set; }
        public Guid ContractStatusId { get; set; }
        public SaleContractFormModel SaleContractFormModel { get; set; }
        public decimal? PurchaseQuantitySum { get; set; }
        public decimal? SalesQuantitySum { get; set; }
        public List<ContractModel> PurchaseContracts { get; set; }
        public List<ContractModel> SalesContracts { get; set; }
        public bool IsInvoiceAccepted { get; set; }
        public Guid? InvoicePaymentStatusId { get; set; }
        public bool IsGeneratedToPayables { get; set; }
        public decimal? RemainingSum { get; set; }
        public bool? IsLinkingCompleted { get; set; }
        public bool IsInvoiceAcceptedByContracter { get; set; }
        public bool IsInvoiceAcceptedBySgtrader { get; set; }
        public bool IsInvoiceRejectedByContracter { get; set; }
        public bool IsInvoiceRejectedBySgtrader { get; set; }
        public object InvoiceStatusName { get; set; }
        public object InvoiceStatusColor { get; set; }
        public Guid? OpenContractStatusId { get; set; }
        public List<Guid> OpenedPurchaseContractIds { get; set; }
        public List<Guid> OpenedSaleContractIds { get; set; }
        public bool IsVesselOwnerorBrokerSignatureVerificationNeed { get; set; }
        public bool IsSGTraderSignatureVerified { get; set; }
        public bool IsVesselOwnerorBrokerSignatureVerified { get; set; }
        public string VesselOwnerorBrokerSignatureRejectedComments { get; set; }
        public string VesselOwnerorBrokerSignatureAcceptedComments { get; set; }
        public bool IsVesselOwnerorBrokerSignatureDone { get; set; }
        public bool IsVesselOwnerorBrokerSignatureAccepted { get; set; }
        public bool IsVesselOwnerorBrokerSignatureRejected { get; set; }
        public Guid? RFQGuid { get; set; }
        public bool? IsRfqConvertedToVessel { get; set; }
        public string VesselContractNumber { get; set; }
        public List<VesselDetailsModel> VesselDetailsModel { get; set; }

        public Guid? SwitchBlDataSetId { get; set; }
        public SwitchBlContractModel SwitchBlContractsModel { get; set; }
        public int? RemainingContractQuantity { get; set; }
        public int HighestBlNumber { get; set; }
        public bool? IsCancelContract { get; set; }
        public string CancelComments { get; set; }
        public decimal CurrentPrice { get; set; }
       
        public List<DebitCreditNoteGenerateModel> CancelledPurchaseContracts { get; set; }
        public List<DebitCreditNoteGenerateModel> CancelledSaleContracts { get; set; }
        public Guid? CancelledStatusId { get; set; }
        public bool? IsCreditNote { get; set; }
        public bool? IsDebitNote { get; set; }
        public bool? IsPdfGenartion { get; set; }
        public Guid? VesselContractId { get; set; }
        public string TermsAndConditions { get; set; }
        public bool? SellerSignatureAcceptance { get; set; }
        public bool? SgSignatureAcceptance { get; set; }
        public bool? VesselOwnerorBrokerSignatureAcceptance { get; set; }
        public object VesselConfirmationFormData { get; set; }
        public DateTime? VesselConfirmationAcceptedDateTime { get; set; }
        public DateTime? VesselConfirmationRejectedDateTime { get; set; }
        public Guid? VesselConfirmationAcceptedByClientUserId { get; set; }
        public Guid? VesselConfirmationAcceptedByTraderUserId { get; set; }
        public Guid? VesselConfirmationRejectedByUserId { get; set; }
        public bool? IsQ88Rejected { get; set; }
        public Guid? VesselConfirmationId { get; set; }
        public List<DraftBlDetails> PurchaseContractDraftBlDetails { get; set; }
        public Guid? TradeId { get; set; }
        public string TradeStatus { get; set; }
        
        public bool IsShareCreditOrDebitNote { get; set; }
        public bool IsAgentInvoiceAcceptedBySGTrader { get; set; }
        public bool? IsQ88Reshared { get; set; }

    }

    public class FinalContractModel
    {
        public Guid? ClientId { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? BrokerId { get; set; }
        public int? RemainingContractQuantity { get; set; }

        public bool IsSelectPercentage { get; set; }
        public bool IsSelectValue { get; set; }
        public bool IsSelectCommodityBroker { get; set; }
        public bool IsSGTraderSignatureVerificationNeed { get; set; }
        public bool IsSellerSignatureVerificationNeed { get; set; }
        public bool IsVesselOwnerorBrokerSignatureVerificationNeed { get; set; }
        public int BrokeragePercentage { get; set; }
        public int BrokerageValue { get; set; }
        public object FormData { get; set; }
        public string ContractType { get; set; }
        public string ContractPdf { get; set; }
        public string SellerSignatureRejectedComments { get; set; }
        public string SellerSignatureAcceptedComments { get; set; }
        public string SgtraderSignatureRejectedComments { get; set; }
        public string SgtraderSignatureAcceptedComments { get; set; }
        public string VesselOwnerorBrokerSignatureRejectedComments { get; set; }
        public string VesselOwnerorBrokerSignatureAcceptedComments { get; set; }
        public string DraftRejectComments { get; set; }
        public string DraftAcceptComments { get; set; }
        public bool? IsDraftRejected { get; set; }
        public bool? IsContractLink { get; set; }
        public List<Guid> PurchaseContractIds { get; set; }
        public List<Guid> SalesContractIds { get; set; }
        public decimal? PurchaseQuantitySum { get; set; }
        public decimal? SalesQuantitySum { get; set; }
        public bool? IsLinkingCompleted { get; set; }
        public Guid? SwitchBlDataSetId { get; set; }
        public string CancelComments { get; set; }
        public decimal CurrentPrice { get; set; }
        public bool? IsCreditNote { get; set; }
        public bool? IsDebitNote { get; set; }
        public string TermsAndConditions { get; set; }
        public bool? SellerSignatureAcceptance { get; set; }
        public bool? VesselOwnerorBrokerSignatureAcceptance { get; set; }
        public bool? SgSignatureAcceptance { get; set; }
        public DateTime?  LinkCreatedDateTime { get; set; }
        public Guid? RFQGuid { get; set; }
        public int? RFQId { get; set; }
        public Guid? TradeId { get; set; }
        public string TradeStatus { get; set; }
        public bool IsShareCreditOrDebitNote { get; set; }
        public bool IsAgentInvoiceAcceptedBySGTrader { get; set; }
        public string RFQUniqueId { get; set; }
        public bool? IsCancelContract { get; set; }

    }

    public class FinalVesselContractModel
    {
        public Guid? ClientId { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? BrokerId { get; set; }
        public bool? IsSelectCommodityBroker { get; set; }
        public bool IsSelectPercentage { get; set; }
        public bool IsSelectValue { get; set; }
        public bool IsSGTraderSignatureVerificationNeed { get; set; }
        public bool IsVesselOwnerorBrokerSignatureVerificationNeed { get; set; }
        public bool IsSGTraderSignatureVerified { get; set; }
        public bool IsVesselOwnerorBrokerSignatureVerified { get; set; }
        public int BrokeragePercentage { get; set; }
        public int BrokerageValue { get; set; }
        public object FormData { get; set; }
        public string ContractType { get; set; }
        public string ContractPdf { get; set; }
        public string VesselOwnerorBrokerSignatureRejectedComments { get; set; }
        public string VesselOwnerorBrokerSignatureAcceptedComments { get; set; }
        public string SgtraderSignatureRejectedComments { get; set; }
        public string SgtraderSignatureAcceptedComments { get; set; }
        public string DraftRejectComments { get; set; }
        public string DraftAcceptComments { get; set; }
        public bool? IsDraftRejected { get; set; }
        public bool? IsContractLink { get; set; }
        public List<Guid> PurchaseContractIds { get; set; }
        public List<Guid> SalesContractIds { get; set; }
        public decimal? PurchaseQuantitySum { get; set; }
        public decimal? SalesQuantitySum { get; set; }
        public bool? IsLinkingCompleted { get; set; }
        public Guid? RFQGuid { get; set; }
        public int? RFQId { get; set; }
        public string RFQUniqueId { get; set; }
        public string VesselContractNumber { get; set; }
        public string CancelComments { get; set; }
        public decimal CurrentPrice { get; set; }
        public bool? IsCreditNote { get; set; }
        public bool? IsDebitNote { get; set; }
        public string TermsAndConditions { get; set; }
        public bool? SgSignatureAcceptance { get; set; }
        public bool? VesselOwnerorBrokerSignatureAcceptance { get; set; }
    }

    public class SaleContractFormModel
    {
        public string ContractNumber { get; set; }
        public string CommodityName { get; set; }
        public string CommodityDescriptionIfAny { get; set; }
        public string ContractType { get; set; }
        public int QuanityNumber { get; set; }
        public string QuantityMeasurementUnit { get; set; }
        public string Tolerance { get; set; }
        public string ToleranceOther { get; set; }
        public string LeadPort { get; set; }
        public string OriginCountry { get; set; }
        public string SellerName { get; set; }
        public string SellerAddressLine1 { get; set; }
        public string SellerAddressLine2 { get; set; }
        public string SellerCountryCode { get; set; }
        public string SellerContact { get; set; }
        public string SellerSignature { get; set; }
        public string SellerSignaturePlace { get; set; }
        public DateTime? SellerSignatureDate { get; set; }
        public string BuyerName { get; set; }
        public string BuyerAddressLine1 { get; set; }
        public string BuyerAddressLine2 { get; set; }
        public string BuyerCountryCode { get; set; }
        public string BuyerContact { get; set; }
        public string BuyerSignature { get; set; }
        public string BuyerSignaturePlace { get; set; }
        public DateTime? BuyerSignatureDate { get; set; }
        public bool IncludeBroker { get; set; }
        public string Commission { get; set; }
        public string BrokerName { get; set; }
        public string BrokerCompany { get; set; }
        public string BrokerAddressLine1 { get; set; }
        public string BrokerAddressLine2 { get; set; }
        public string BrokerCountryCode { get; set; }
        public string BrokerContact { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public string PriceCurrency { get; set; }
        public string PriceAmount { get; set; }
        public string PricePerUnit { get; set; }
        public string Incoterms { get; set; }
        public string AdditionalCommentsIfAny { get; set; }
        public bool IrrevocableDocumentCredit { get; set; }
        public bool ElectronicFundsTransfer { get; set; }
        public string BeneficiaryName { get; set; }
        public string AccountNumber { get; set; }
        public string BankName { get; set; }
        public string BankAddress { get; set; }
        public string SWIFT { get; set; }
        public string CorrespondentAddress { get; set; }
        public string ABAOrSWIFT { get; set; }
        public string PlaceOfIssue { get; set; }
        public string PlaceOfConformation { get; set; }
        public string ByPaymentAtSight { get; set; }
        public string ByDeferredPaymentAt { get; set; }
        public string ByAcceptanceOfDraftAt { get; set; }
        public string DaysBeforeDayOfDelivery { get; set; }
        public string ByNegotiation  { get; set; }
        public int Days  { get; set; }
        public bool Allowed  { get; set; }
        public bool NotAllowed  { get; set; }
        public string OtherText { get; set; }
        public string DocumentsRequired { get; set; }
        public string PlaceOfArbitration { get; set; }
        public string PlaceOfLitigation { get; set; }
       
    }


    public class ParamsJsonModel
    {
        public string KeyName { get; set; }
        public string KeyValue { get; set; }
        public string Type { get; set; }
    }

    public class VesselDetailsModel
    {
        public Guid VesselId { get; set; }
        public List<Guid> PurchaseContractIds { get; set; }
        public List<Guid> SalesContractIds { get; set; }
        public decimal? PurchaseQuantitySum { get; set; }
        public decimal? SalesQuantitySum { get; set; }
    }

    public class DebitCreditNoteGenerateModel
    {
        public Guid? DataSetId { get; set; }
        public object FormData { get; set; }
        public bool? IsCreditNote { get; set; }
        public bool? IsDebitNote { get; set; }
        public string CancelComments { get; set; }
        public decimal CurrentPrice { get; set; }
        public Guid? ContractTemplateId { get; set; }
        public string TemplateData { get; set; }

        public string CommodityName { get; set; }

    }

    public class RFQListContractModel
    {
        public Guid? DataSetId { get; set; }
        public Guid? ContractTemplateId { get; set; }
        public object FormData { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? BrokerId { get; set; }
        public string ContractType { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? ReferenceId { get; set; }
        public string ReferenceUserName { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public int? RFQId { get; set; }
        public Guid? VesselContractId { get; set; }
    }
}
