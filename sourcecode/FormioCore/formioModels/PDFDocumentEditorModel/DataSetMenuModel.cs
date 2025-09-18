using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System.Text.Json.Serialization;

namespace PDFHTMLDesignerModels.SFDTParameterModel
{
    public class CreatedDateTime
    {
        [JsonProperty("$date")]
        public Date date { get; set; }
    }

    public class DataGrid
    {
        public string invoiceNumber { get; set; }
        public List<DataGrid2> dataGrid2 { get; set; }
        public List<object> components { get; set; }
        public string uniqueIdInvoice { get; set; }
        public int invoiceValue { get; set; }
        public int invoiceQuantityMt { get; set; }
    }

    public class DataGrid2
    {
        public string blNumber { get; set; }
        public string portionNumber { get; set; }
        public string deliveryPeriod { get; set; }
        public int finalValue { get; set; }
        public List<object> components { get; set; }
        public string uniqueId { get; set; }
        public int openTraderQuantityMt { get; set; }
        public int finalPrice { get; set; }
        public int finalValueUsd { get; set; }
        public string selectBl { get; set; }
        public int blQuantityMt { get; set; }
        public int finalPriceUsd { get; set; }
    }

    public class DataJson
    {
        public FormData FormData { get; set; }
        public string CustomApplicationId { get; set; }
        public object ClientId { get; set; }
        public object StatusId { get; set; }
        public object VesselConfirmationStatusId { get; set; }
        public object VesselConfirmationTemplateId { get; set; }
        public object BrokerId { get; set; }
        public bool IsSelectPercentage { get; set; }
        public bool IsSelectCommodityBroker { get; set; }
        public bool IsSelectValue { get; set; }
        public bool IsSGTraderSignatureVerificationNeed { get; set; }
        public bool IsSellerSignatureVerificationNeed { get; set; }
        public int BrokeragePercentage { get; set; }
        public int BrokerageValue { get; set; }
        public object ContractPdf { get; set; }
        public string ContractType { get; set; }
        public string UniqueNumber { get; set; }
        public object SellerSignatureRejectedComments { get; set; }
        public object SellerSignatureAcceptedComments { get; set; }
        public object SgtraderSignatureRejectedComments { get; set; }
        public object SgtraderSignatureAcceptedComments { get; set; }
        public object DraftRejectComments { get; set; }
        public object DraftAcceptComments { get; set; }
        public object ReferenceId { get; set; }
        public object TemplateTypeId { get; set; }
        public object ContractNumber { get; set; }
        public object CommodityName { get; set; }
        public object CommodityDescriptionIfAny { get; set; }
        public int QuanityNumber { get; set; }
        public object QuantityMeasurementUnit { get; set; }
        public object Tolerance { get; set; }
        public object VesselContractStatusId { get; set; }
        public object ToleranceOther { get; set; }
        public object LeadPort { get; set; }
        public object OriginCountry { get; set; }
        public object SellerName { get; set; }
        public object SellerAddressLine1 { get; set; }
        public object SellerAddressLine2 { get; set; }
        public object SellerCountryCode { get; set; }
        public object SellerContact { get; set; }
        public object SellerSignature { get; set; }
        public object SellerSignaturePlace { get; set; }
        public object SellerSignatureDate { get; set; }
        public object BuyerName { get; set; }
        public object BuyerAddressLine1 { get; set; }
        public object BuyerAddressLine2 { get; set; }
        public object BuyerCountryCode { get; set; }
        public object BuyerContact { get; set; }
        public object BuyerSignature { get; set; }
        public object BuyerSignaturePlace { get; set; }
        public object BuyerSignatureDate { get; set; }
        public bool IncludeBroker { get; set; }
        public object Commission { get; set; }
        public object BrokerName { get; set; }
        public object BrokerCompany { get; set; }
        public object BrokerAddressLine1 { get; set; }
        public object BrokerAddressLine2 { get; set; }
        public object BrokerCountryCode { get; set; }
        public object BrokerContact { get; set; }
        public object FromDate { get; set; }
        public object ToDate { get; set; }
        public object PriceCurrency { get; set; }
        public object PriceAmount { get; set; }
        public object PricePerUnit { get; set; }
        public object Incoterms { get; set; }
        public object AdditionalCommentsIfAny { get; set; }
        public bool IrrevocableDocumentCredit { get; set; }
        public bool ElectronicFundsTransfer { get; set; }
        public object BeneficiaryName { get; set; }
        public object AccountNumber { get; set; }
        public object BankName { get; set; }
        public object BankAddress { get; set; }
        public object SWIFT { get; set; }
        public object CorrespondentAddress { get; set; }
        public object ABAOrSWIFT { get; set; }
        public object PlaceOfIssue { get; set; }
        public object PlaceOfConformation { get; set; }
        public object ByPaymentAtSight { get; set; }
        public object ByDeferredPaymentAt { get; set; }
        public object ByAcceptanceOfDraftAt { get; set; }
        public object DaysBeforeDayOfDelivery { get; set; }
        public object ByNegotiation { get; set; }
        public object ExecutionSteps { get; set; }
        public int Days { get; set; }
        public bool Allowed { get; set; }
        public bool NotAllowed { get; set; }
        public object OtherText { get; set; }
        public object DocumentsRequired { get; set; }
        public object PlaceOfArbitration { get; set; }
        public object PlaceOfLitigation { get; set; }
        public object AcceptedByClientUserId { get; set; }
        public object AcceptedByTraderUserId { get; set; }
        public object IsAccepted { get; set; }
        public object IsRejected { get; set; }
        public object IsVesselConfirmationAccepted { get; set; }
        public object IsVesselConfirmationRejected { get; set; }
        public object RejectedComments { get; set; }
        public object Version { get; set; }
        public object RFQId { get; set; }
        public object RFQUniqueId { get; set; }
        public object ContractId { get; set; }
        public object InvoiceId { get; set; }
        public object Q88SharedClientIds { get; set; }
        public object Q88SharedUserIds { get; set; }
        public object Q88AcceptedIds { get; set; }
        public object Q88RejectedIds { get; set; }
        public object Q88Reject { get; set; }
        public object RFQAcceptedDateTime { get; set; }
        public object RFQRejectedDateTime { get; set; }
        public object IsQ88Accepted { get; set; }
        public object IsContractLink { get; set; }
        public object PurchaseContractIds { get; set; }
        public object SalesContractIds { get; set; }
        public object PurchaseQuantitySum { get; set; }
        public object SalesQuantitySum { get; set; }
        public object VesselId { get; set; }
        public object VesselQuantity { get; set; }
        public bool IsShareSwitchBlContract { get; set; }
        public bool IsSwitchBl { get; set; }
        public object SwitchBlDetails { get; set; }
        public object PurchaseBlDetails { get; set; }
        public object SaleContractId { get; set; }
        public object VesselOwnerId { get; set; }
        public object StatusName { get; set; }
        public object PurchaseContracts { get; set; }
        public object SalesContracts { get; set; }
        public object IsLinkingCompleted { get; set; }
        public object ContracterInvoiceAcceptedComments { get; set; }
        public object SgtraderInvoiceRejectedComments { get; set; }
        public object ContracterInvoiceRejectedComments { get; set; }
        public object SgtraderInvoiceAcceptedComments { get; set; }
        public object InvoicePaymentStatusId { get; set; }
        public object ApprovedDate { get; set; }
        public object PaidDate { get; set; }
        public string InvoiceType { get; set; }
        public bool IsGeneratedToPayables { get; set; }
        public object InvoicePdfUrl { get; set; }
        public object IsRfqConvertedToVessel { get; set; }
        public object RFQGuid { get; set; }
        public string Status { get; set; }
        public bool IsVesselOwnerorBrokerSignatureVerificationNeed { get; set; }
        public bool IsSGTraderSignatureVerified { get; set; }
        public bool IsVesselOwnerorBrokerSignatureVerified { get; set; }
        public object VesselOwnerorBrokerSignatureRejectedComments { get; set; }
        public object VesselOwnerorBrokerSignatureAcceptedComments { get; set; }
        public object SwitchBlDataSetId { get; set; }
        public object RemainingContractQuantity { get; set; }
        public object IsVesselOwnerAccepted { get; set; }
        public object IsContractSharedToVesselOwner { get; set; }
        public object TermsAndConditions { get; set; }
        public object SellerSignatureAcceptance { get; set; }
        public object SgSignatureAcceptance { get; set; }
        public object VesselOwnerorBrokerSignatureAcceptance { get; set; }
        public object LinkCreatedDateTime { get; set; }
        public object BlDraftForm { get; set; }
        public object IsCreditNote { get; set; }
        public object IsDebitNote { get; set; }
        public object VesselConfirmationFormData { get; set; }
        public object VesselConfirmationAcceptedDateTime { get; set; }
        public object VesselConfirmationRejectedDateTime { get; set; }
        public object VesselConfirmationAcceptedByClientUserId { get; set; }
        public object VesselConfirmationAcceptedByTraderUserId { get; set; }
        public object VesselConfirmationRejectedByUserId { get; set; }
        public object IsQ88Rejected { get; set; }
        public object VesselConfirmationId { get; set; }
        public object IsVesselContract { get; set; }
        public object TradeId { get; set; }
        public object TradeStatus { get; set; }
        public object BuyerAcceptComment { get; set; }
        public object BuyerRejectComment { get; set; }
        public object VesselOwnerAcceptComment { get; set; }
        public object VesselOwnerRejectComment { get; set; }
        public object IsCancelContract { get; set; }
        public object IsQ88Reshared { get; set; }
    }

    public class Date
    {
        [JsonProperty("$numberLong")]
        public string numberLong { get; set; }
    }

    public class FormData
    {
        public string trader1 { get; set; }
        public string productGroup { get; set; }
        public DateTime tradeDate { get; set; }
        public string counterparty { get; set; }
        public string deliveryTerm { get; set; }
        public string deliveryPeriod { get; set; }
        public string futurePeriod { get; set; }
        public string company { get; set; }
        public string contractNumber { get; set; }
        public List<DataGrid> dataGrid { get; set; }
        public bool save { get; set; }
        public bool draft { get; set; }
        public bool submit { get; set; }
        public int totalFinalValue { get; set; }
        public string commodity4 { get; set; }
        public string textField { get; set; }
        public string textField1 { get; set; }
        public string vesselName { get; set; }
        public string commodity { get; set; }
        public VesselNamelookupchilddata vesselNamelookupchilddata { get; set; }

        [JsonProperty("Created User")]
        public string CreatedUser { get; set; }

        [JsonProperty("Created Date")]
        public string CreatedDate { get; set; }
        public string createdBy { get; set; }
        public object provisionalValueUsd { get; set; }

        [JsonProperty("Updated User")]
        public string UpdatedUser { get; set; }

        [JsonProperty("Updated Date")]
        public string UpdatedDate { get; set; }
        public string updatedBy { get; set; }

        [JsonProperty("selectBlTIGER GLORY__JNPT, India_PG/JNPT-06lookupchilddata")]
        public SelectBlTIGERGLORYJNPTIndiaPGJNPT06lookupchilddata selectBlTIGERGLORY__JNPTIndia_PGJNPT06lookupchilddata { get; set; }

        [JsonProperty("selectBlTIGER GLORY__JNPT, India_PG/JNPT-07lookupchilddata")]
        public SelectBlTIGERGLORYJNPTIndiaPGJNPT07lookupchilddata selectBlTIGERGLORY__JNPTIndia_PGJNPT07lookupchilddata { get; set; }

        [JsonProperty("selectBlTIGER GLORY__JNPT, India_PG/JNPT-08lookupchilddata")]
        public SelectBlTIGERGLORYJNPTIndiaPGJNPT08lookupchilddata selectBlTIGERGLORY__JNPTIndia_PGJNPT08lookupchilddata { get; set; }

        [JsonProperty("selectBlTIGER GLORY__JNPT, India_PG/JNPT-09lookupchilddata")]
        public SelectBlTIGERGLORYJNPTIndiaPGJNPT09lookupchilddata selectBlTIGERGLORY__JNPTIndia_PGJNPT09lookupchilddata { get; set; }

        [JsonProperty("selectBlTIGER GLORY__JNPT, India_PG/JNPT-10lookupchilddata")]
        public SelectBlTIGERGLORYJNPTIndiaPGJNPT10lookupchilddata selectBlTIGERGLORY__JNPTIndia_PGJNPT10lookupchilddata { get; set; }

        [JsonProperty("selectBlTIGER GLORY__JNPT, India_PG/JNPT-11lookupchilddata")]
        public SelectBlTIGERGLORYJNPTIndiaPGJNPT11lookupchilddata selectBlTIGERGLORY__JNPTIndia_PGJNPT11lookupchilddata { get; set; }
    }

    public class DataSetMenuModel
    {
        public string _id { get; set; }
        public string InputCommandGuid { get; set; }
        public string InputCommandTypeGuid { get; set; }
        public object TimeStamp { get; set; }
        public string DataSourceId { get; set; }
        public string CompanyId { get; set; }
        public string CreatedByUserId { get; set; }
        public string UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public object ArchivedDateTime { get; set; }
        public object DataJson { get; set; }
        public bool IsArchived { get; set; }
        public object IsNewRecord { get; set; }
    }

    public class SelectBlTIGERGLORYJNPTIndiaPGJNPT06lookupchilddata
    {
        public string vesselName { get; set; }

        [JsonProperty("vesselName-Type")]
        public string vesselNameType { get; set; }

        [JsonProperty("vesselName-Format")]
        public object vesselNameFormat { get; set; }

        [JsonProperty("vesselName-DecimalLimit")]
        public object vesselNameDecimalLimit { get; set; }

        [JsonProperty("vesselName-RequireDecimal")]
        public object vesselNameRequireDecimal { get; set; }

        [JsonProperty("vesselName-Delimiter")]
        public object vesselNameDelimiter { get; set; }
        public string voyageNumber { get; set; }

        [JsonProperty("voyageNumber-Type")]
        public string voyageNumberType { get; set; }

        [JsonProperty("voyageNumber-Format")]
        public object voyageNumberFormat { get; set; }

        [JsonProperty("voyageNumber-DecimalLimit")]
        public object voyageNumberDecimalLimit { get; set; }

        [JsonProperty("voyageNumber-RequireDecimal")]
        public object voyageNumberRequireDecimal { get; set; }

        [JsonProperty("voyageNumber-Delimiter")]
        public object voyageNumberDelimiter { get; set; }
        public string blNumber { get; set; }

        [JsonProperty("blNumber-Type")]
        public string blNumberType { get; set; }

        [JsonProperty("blNumber-Format")]
        public object blNumberFormat { get; set; }

        [JsonProperty("blNumber-DecimalLimit")]
        public object blNumberDecimalLimit { get; set; }

        [JsonProperty("blNumber-RequireDecimal")]
        public object blNumberRequireDecimal { get; set; }

        [JsonProperty("blNumber-Delimiter")]
        public object blNumberDelimiter { get; set; }
        public int blQuantityMt { get; set; }

        [JsonProperty("blQuantityMt-Type")]
        public string blQuantityMtType { get; set; }

        [JsonProperty("blQuantityMt-Format")]
        public object blQuantityMtFormat { get; set; }

        [JsonProperty("blQuantityMt-DecimalLimit")]
        public int blQuantityMtDecimalLimit { get; set; }

        [JsonProperty("blQuantityMt-RequireDecimal")]
        public bool blQuantityMtRequireDecimal { get; set; }

        [JsonProperty("blQuantityMt-Delimiter")]
        public bool blQuantityMtDelimiter { get; set; }
        public string portOfOrigin { get; set; }

        [JsonProperty("portOfOrigin-Type")]
        public string portOfOriginType { get; set; }

        [JsonProperty("portOfOrigin-Format")]
        public object portOfOriginFormat { get; set; }

        [JsonProperty("portOfOrigin-DecimalLimit")]
        public object portOfOriginDecimalLimit { get; set; }

        [JsonProperty("portOfOrigin-RequireDecimal")]
        public object portOfOriginRequireDecimal { get; set; }

        [JsonProperty("portOfOrigin-Delimiter")]
        public object portOfOriginDelimiter { get; set; }
        public string portOfOrigin1 { get; set; }

        [JsonProperty("portOfOrigin1-Type")]
        public string portOfOrigin1Type { get; set; }

        [JsonProperty("portOfOrigin1-Format")]
        public object portOfOrigin1Format { get; set; }

        [JsonProperty("portOfOrigin1-DecimalLimit")]
        public object portOfOrigin1DecimalLimit { get; set; }

        [JsonProperty("portOfOrigin1-RequireDecimal")]
        public object portOfOrigin1RequireDecimal { get; set; }

        [JsonProperty("portOfOrigin1-Delimiter")]
        public object portOfOrigin1Delimiter { get; set; }
    }

    public class SelectBlTIGERGLORYJNPTIndiaPGJNPT07lookupchilddata
    {
        public string vesselName { get; set; }

        [JsonProperty("vesselName-Type")]
        public string vesselNameType { get; set; }

        [JsonProperty("vesselName-Format")]
        public object vesselNameFormat { get; set; }

        [JsonProperty("vesselName-DecimalLimit")]
        public object vesselNameDecimalLimit { get; set; }

        [JsonProperty("vesselName-RequireDecimal")]
        public object vesselNameRequireDecimal { get; set; }

        [JsonProperty("vesselName-Delimiter")]
        public object vesselNameDelimiter { get; set; }
        public string voyageNumber { get; set; }

        [JsonProperty("voyageNumber-Type")]
        public string voyageNumberType { get; set; }

        [JsonProperty("voyageNumber-Format")]
        public object voyageNumberFormat { get; set; }

        [JsonProperty("voyageNumber-DecimalLimit")]
        public object voyageNumberDecimalLimit { get; set; }

        [JsonProperty("voyageNumber-RequireDecimal")]
        public object voyageNumberRequireDecimal { get; set; }

        [JsonProperty("voyageNumber-Delimiter")]
        public object voyageNumberDelimiter { get; set; }
        public string blNumber { get; set; }

        [JsonProperty("blNumber-Type")]
        public string blNumberType { get; set; }

        [JsonProperty("blNumber-Format")]
        public object blNumberFormat { get; set; }

        [JsonProperty("blNumber-DecimalLimit")]
        public object blNumberDecimalLimit { get; set; }

        [JsonProperty("blNumber-RequireDecimal")]
        public object blNumberRequireDecimal { get; set; }

        [JsonProperty("blNumber-Delimiter")]
        public object blNumberDelimiter { get; set; }
        public int blQuantityMt { get; set; }

        [JsonProperty("blQuantityMt-Type")]
        public string blQuantityMtType { get; set; }

        [JsonProperty("blQuantityMt-Format")]
        public object blQuantityMtFormat { get; set; }

        [JsonProperty("blQuantityMt-DecimalLimit")]
        public int blQuantityMtDecimalLimit { get; set; }

        [JsonProperty("blQuantityMt-RequireDecimal")]
        public bool blQuantityMtRequireDecimal { get; set; }

        [JsonProperty("blQuantityMt-Delimiter")]
        public bool blQuantityMtDelimiter { get; set; }
        public string portOfOrigin { get; set; }

        [JsonProperty("portOfOrigin-Type")]
        public string portOfOriginType { get; set; }

        [JsonProperty("portOfOrigin-Format")]
        public object portOfOriginFormat { get; set; }

        [JsonProperty("portOfOrigin-DecimalLimit")]
        public object portOfOriginDecimalLimit { get; set; }

        [JsonProperty("portOfOrigin-RequireDecimal")]
        public object portOfOriginRequireDecimal { get; set; }

        [JsonProperty("portOfOrigin-Delimiter")]
        public object portOfOriginDelimiter { get; set; }
        public string portOfOrigin1 { get; set; }

        [JsonProperty("portOfOrigin1-Type")]
        public string portOfOrigin1Type { get; set; }

        [JsonProperty("portOfOrigin1-Format")]
        public object portOfOrigin1Format { get; set; }

        [JsonProperty("portOfOrigin1-DecimalLimit")]
        public object portOfOrigin1DecimalLimit { get; set; }

        [JsonProperty("portOfOrigin1-RequireDecimal")]
        public object portOfOrigin1RequireDecimal { get; set; }

        [JsonProperty("portOfOrigin1-Delimiter")]
        public object portOfOrigin1Delimiter { get; set; }
    }

    public class SelectBlTIGERGLORYJNPTIndiaPGJNPT08lookupchilddata
    {
        public string vesselName { get; set; }

        [JsonProperty("vesselName-Type")]
        public string vesselNameType { get; set; }

        [JsonProperty("vesselName-Format")]
        public object vesselNameFormat { get; set; }

        [JsonProperty("vesselName-DecimalLimit")]
        public object vesselNameDecimalLimit { get; set; }

        [JsonProperty("vesselName-RequireDecimal")]
        public object vesselNameRequireDecimal { get; set; }

        [JsonProperty("vesselName-Delimiter")]
        public object vesselNameDelimiter { get; set; }
        public string voyageNumber { get; set; }

        [JsonProperty("voyageNumber-Type")]
        public string voyageNumberType { get; set; }

        [JsonProperty("voyageNumber-Format")]
        public object voyageNumberFormat { get; set; }

        [JsonProperty("voyageNumber-DecimalLimit")]
        public object voyageNumberDecimalLimit { get; set; }

        [JsonProperty("voyageNumber-RequireDecimal")]
        public object voyageNumberRequireDecimal { get; set; }

        [JsonProperty("voyageNumber-Delimiter")]
        public object voyageNumberDelimiter { get; set; }
        public string blNumber { get; set; }

        [JsonProperty("blNumber-Type")]
        public string blNumberType { get; set; }

        [JsonProperty("blNumber-Format")]
        public object blNumberFormat { get; set; }

        [JsonProperty("blNumber-DecimalLimit")]
        public object blNumberDecimalLimit { get; set; }

        [JsonProperty("blNumber-RequireDecimal")]
        public object blNumberRequireDecimal { get; set; }

        [JsonProperty("blNumber-Delimiter")]
        public object blNumberDelimiter { get; set; }
        public int blQuantityMt { get; set; }

        [JsonProperty("blQuantityMt-Type")]
        public string blQuantityMtType { get; set; }

        [JsonProperty("blQuantityMt-Format")]
        public object blQuantityMtFormat { get; set; }

        [JsonProperty("blQuantityMt-DecimalLimit")]
        public int blQuantityMtDecimalLimit { get; set; }

        [JsonProperty("blQuantityMt-RequireDecimal")]
        public bool blQuantityMtRequireDecimal { get; set; }

        [JsonProperty("blQuantityMt-Delimiter")]
        public bool blQuantityMtDelimiter { get; set; }
        public string portOfOrigin { get; set; }

        [JsonProperty("portOfOrigin-Type")]
        public string portOfOriginType { get; set; }

        [JsonProperty("portOfOrigin-Format")]
        public object portOfOriginFormat { get; set; }

        [JsonProperty("portOfOrigin-DecimalLimit")]
        public object portOfOriginDecimalLimit { get; set; }

        [JsonProperty("portOfOrigin-RequireDecimal")]
        public object portOfOriginRequireDecimal { get; set; }

        [JsonProperty("portOfOrigin-Delimiter")]
        public object portOfOriginDelimiter { get; set; }
        public string portOfOrigin1 { get; set; }

        [JsonProperty("portOfOrigin1-Type")]
        public string portOfOrigin1Type { get; set; }

        [JsonProperty("portOfOrigin1-Format")]
        public object portOfOrigin1Format { get; set; }

        [JsonProperty("portOfOrigin1-DecimalLimit")]
        public object portOfOrigin1DecimalLimit { get; set; }

        [JsonProperty("portOfOrigin1-RequireDecimal")]
        public object portOfOrigin1RequireDecimal { get; set; }

        [JsonProperty("portOfOrigin1-Delimiter")]
        public object portOfOrigin1Delimiter { get; set; }
    }

    public class SelectBlTIGERGLORYJNPTIndiaPGJNPT09lookupchilddata
    {
        public string vesselName { get; set; }

        [JsonProperty("vesselName-Type")]
        public string vesselNameType { get; set; }

        [JsonProperty("vesselName-Format")]
        public object vesselNameFormat { get; set; }

        [JsonProperty("vesselName-DecimalLimit")]
        public object vesselNameDecimalLimit { get; set; }

        [JsonProperty("vesselName-RequireDecimal")]
        public object vesselNameRequireDecimal { get; set; }

        [JsonProperty("vesselName-Delimiter")]
        public object vesselNameDelimiter { get; set; }
        public string voyageNumber { get; set; }

        [JsonProperty("voyageNumber-Type")]
        public string voyageNumberType { get; set; }

        [JsonProperty("voyageNumber-Format")]
        public object voyageNumberFormat { get; set; }

        [JsonProperty("voyageNumber-DecimalLimit")]
        public object voyageNumberDecimalLimit { get; set; }

        [JsonProperty("voyageNumber-RequireDecimal")]
        public object voyageNumberRequireDecimal { get; set; }

        [JsonProperty("voyageNumber-Delimiter")]
        public object voyageNumberDelimiter { get; set; }
        public string blNumber { get; set; }

        [JsonProperty("blNumber-Type")]
        public string blNumberType { get; set; }

        [JsonProperty("blNumber-Format")]
        public object blNumberFormat { get; set; }

        [JsonProperty("blNumber-DecimalLimit")]
        public object blNumberDecimalLimit { get; set; }

        [JsonProperty("blNumber-RequireDecimal")]
        public object blNumberRequireDecimal { get; set; }

        [JsonProperty("blNumber-Delimiter")]
        public object blNumberDelimiter { get; set; }
        public int blQuantityMt { get; set; }

        [JsonProperty("blQuantityMt-Type")]
        public string blQuantityMtType { get; set; }

        [JsonProperty("blQuantityMt-Format")]
        public object blQuantityMtFormat { get; set; }

        [JsonProperty("blQuantityMt-DecimalLimit")]
        public int blQuantityMtDecimalLimit { get; set; }

        [JsonProperty("blQuantityMt-RequireDecimal")]
        public bool blQuantityMtRequireDecimal { get; set; }

        [JsonProperty("blQuantityMt-Delimiter")]
        public bool blQuantityMtDelimiter { get; set; }
        public string portOfOrigin { get; set; }

        [JsonProperty("portOfOrigin-Type")]
        public string portOfOriginType { get; set; }

        [JsonProperty("portOfOrigin-Format")]
        public object portOfOriginFormat { get; set; }

        [JsonProperty("portOfOrigin-DecimalLimit")]
        public object portOfOriginDecimalLimit { get; set; }

        [JsonProperty("portOfOrigin-RequireDecimal")]
        public object portOfOriginRequireDecimal { get; set; }

        [JsonProperty("portOfOrigin-Delimiter")]
        public object portOfOriginDelimiter { get; set; }
        public string portOfOrigin1 { get; set; }

        [JsonProperty("portOfOrigin1-Type")]
        public string portOfOrigin1Type { get; set; }

        [JsonProperty("portOfOrigin1-Format")]
        public object portOfOrigin1Format { get; set; }

        [JsonProperty("portOfOrigin1-DecimalLimit")]
        public object portOfOrigin1DecimalLimit { get; set; }

        [JsonProperty("portOfOrigin1-RequireDecimal")]
        public object portOfOrigin1RequireDecimal { get; set; }

        [JsonProperty("portOfOrigin1-Delimiter")]
        public object portOfOrigin1Delimiter { get; set; }
    }

    public class SelectBlTIGERGLORYJNPTIndiaPGJNPT10lookupchilddata
    {
        public string vesselName { get; set; }

        [JsonProperty("vesselName-Type")]
        public string vesselNameType { get; set; }

        [JsonProperty("vesselName-Format")]
        public object vesselNameFormat { get; set; }

        [JsonProperty("vesselName-DecimalLimit")]
        public object vesselNameDecimalLimit { get; set; }

        [JsonProperty("vesselName-RequireDecimal")]
        public object vesselNameRequireDecimal { get; set; }

        [JsonProperty("vesselName-Delimiter")]
        public object vesselNameDelimiter { get; set; }
        public string voyageNumber { get; set; }

        [JsonProperty("voyageNumber-Type")]
        public string voyageNumberType { get; set; }

        [JsonProperty("voyageNumber-Format")]
        public object voyageNumberFormat { get; set; }

        [JsonProperty("voyageNumber-DecimalLimit")]
        public object voyageNumberDecimalLimit { get; set; }

        [JsonProperty("voyageNumber-RequireDecimal")]
        public object voyageNumberRequireDecimal { get; set; }

        [JsonProperty("voyageNumber-Delimiter")]
        public object voyageNumberDelimiter { get; set; }
        public string blNumber { get; set; }

        [JsonProperty("blNumber-Type")]
        public string blNumberType { get; set; }

        [JsonProperty("blNumber-Format")]
        public object blNumberFormat { get; set; }

        [JsonProperty("blNumber-DecimalLimit")]
        public object blNumberDecimalLimit { get; set; }

        [JsonProperty("blNumber-RequireDecimal")]
        public object blNumberRequireDecimal { get; set; }

        [JsonProperty("blNumber-Delimiter")]
        public object blNumberDelimiter { get; set; }
        public int blQuantityMt { get; set; }

        [JsonProperty("blQuantityMt-Type")]
        public string blQuantityMtType { get; set; }

        [JsonProperty("blQuantityMt-Format")]
        public object blQuantityMtFormat { get; set; }

        [JsonProperty("blQuantityMt-DecimalLimit")]
        public int blQuantityMtDecimalLimit { get; set; }

        [JsonProperty("blQuantityMt-RequireDecimal")]
        public bool blQuantityMtRequireDecimal { get; set; }

        [JsonProperty("blQuantityMt-Delimiter")]
        public bool blQuantityMtDelimiter { get; set; }
        public string portOfOrigin { get; set; }

        [JsonProperty("portOfOrigin-Type")]
        public string portOfOriginType { get; set; }

        [JsonProperty("portOfOrigin-Format")]
        public object portOfOriginFormat { get; set; }

        [JsonProperty("portOfOrigin-DecimalLimit")]
        public object portOfOriginDecimalLimit { get; set; }

        [JsonProperty("portOfOrigin-RequireDecimal")]
        public object portOfOriginRequireDecimal { get; set; }

        [JsonProperty("portOfOrigin-Delimiter")]
        public object portOfOriginDelimiter { get; set; }
        public string portOfOrigin1 { get; set; }

        [JsonProperty("portOfOrigin1-Type")]
        public string portOfOrigin1Type { get; set; }

        [JsonProperty("portOfOrigin1-Format")]
        public object portOfOrigin1Format { get; set; }

        [JsonProperty("portOfOrigin1-DecimalLimit")]
        public object portOfOrigin1DecimalLimit { get; set; }

        [JsonProperty("portOfOrigin1-RequireDecimal")]
        public object portOfOrigin1RequireDecimal { get; set; }

        [JsonProperty("portOfOrigin1-Delimiter")]
        public object portOfOrigin1Delimiter { get; set; }
    }

    public class SelectBlTIGERGLORYJNPTIndiaPGJNPT11lookupchilddata
    {
        public string vesselName { get; set; }

        [JsonProperty("vesselName-Type")]
        public string vesselNameType { get; set; }

        [JsonProperty("vesselName-Format")]
        public object vesselNameFormat { get; set; }

        [JsonProperty("vesselName-DecimalLimit")]
        public object vesselNameDecimalLimit { get; set; }

        [JsonProperty("vesselName-RequireDecimal")]
        public object vesselNameRequireDecimal { get; set; }

        [JsonProperty("vesselName-Delimiter")]
        public object vesselNameDelimiter { get; set; }
        public string voyageNumber { get; set; }

        [JsonProperty("voyageNumber-Type")]
        public string voyageNumberType { get; set; }

        [JsonProperty("voyageNumber-Format")]
        public object voyageNumberFormat { get; set; }

        [JsonProperty("voyageNumber-DecimalLimit")]
        public object voyageNumberDecimalLimit { get; set; }

        [JsonProperty("voyageNumber-RequireDecimal")]
        public object voyageNumberRequireDecimal { get; set; }

        [JsonProperty("voyageNumber-Delimiter")]
        public object voyageNumberDelimiter { get; set; }
        public string blNumber { get; set; }

        [JsonProperty("blNumber-Type")]
        public string blNumberType { get; set; }

        [JsonProperty("blNumber-Format")]
        public object blNumberFormat { get; set; }

        [JsonProperty("blNumber-DecimalLimit")]
        public object blNumberDecimalLimit { get; set; }

        [JsonProperty("blNumber-RequireDecimal")]
        public object blNumberRequireDecimal { get; set; }

        [JsonProperty("blNumber-Delimiter")]
        public object blNumberDelimiter { get; set; }
        public int blQuantityMt { get; set; }

        [JsonProperty("blQuantityMt-Type")]
        public string blQuantityMtType { get; set; }

        [JsonProperty("blQuantityMt-Format")]
        public object blQuantityMtFormat { get; set; }

        [JsonProperty("blQuantityMt-DecimalLimit")]
        public int blQuantityMtDecimalLimit { get; set; }

        [JsonProperty("blQuantityMt-RequireDecimal")]
        public bool blQuantityMtRequireDecimal { get; set; }

        [JsonProperty("blQuantityMt-Delimiter")]
        public bool blQuantityMtDelimiter { get; set; }
        public string portOfOrigin { get; set; }

        [JsonProperty("portOfOrigin-Type")]
        public string portOfOriginType { get; set; }

        [JsonProperty("portOfOrigin-Format")]
        public object portOfOriginFormat { get; set; }

        [JsonProperty("portOfOrigin-DecimalLimit")]
        public object portOfOriginDecimalLimit { get; set; }

        [JsonProperty("portOfOrigin-RequireDecimal")]
        public object portOfOriginRequireDecimal { get; set; }

        [JsonProperty("portOfOrigin-Delimiter")]
        public object portOfOriginDelimiter { get; set; }
        public string portOfOrigin1 { get; set; }

        [JsonProperty("portOfOrigin1-Type")]
        public string portOfOrigin1Type { get; set; }

        [JsonProperty("portOfOrigin1-Format")]
        public object portOfOrigin1Format { get; set; }

        [JsonProperty("portOfOrigin1-DecimalLimit")]
        public object portOfOrigin1DecimalLimit { get; set; }

        [JsonProperty("portOfOrigin1-RequireDecimal")]
        public object portOfOrigin1RequireDecimal { get; set; }

        [JsonProperty("portOfOrigin1-Delimiter")]
        public object portOfOrigin1Delimiter { get; set; }
    }

    public class UpdatedDateTime
    {
        [JsonProperty("$date")]
        public Date date { get; set; }
    }

    public class VesselNamelookupchilddata
    {
        public string voyageNumber { get; set; }
        public string portOfOrigin1 { get; set; }
        public int totalVesselQuantity { get; set; }

        [JsonProperty("voyageNumber-Type")]
        public string voyageNumberType { get; set; }

        [JsonProperty("portOfOrigin1-Type")]
        public string portOfOrigin1Type { get; set; }

        [JsonProperty("totalVesselQuantity-Type")]
        public string totalVesselQuantityType { get; set; }

        [JsonProperty("voyageNumber-Format")]
        public string voyageNumberFormat { get; set; }

        [JsonProperty("portOfOrigin1-Format")]
        public string portOfOrigin1Format { get; set; }

        [JsonProperty("totalVesselQuantity-Format")]
        public string totalVesselQuantityFormat { get; set; }

        [JsonProperty("voyageNumber-Delimiter")]
        public string voyageNumberDelimiter { get; set; }

        [JsonProperty("portOfOrigin1-Delimiter")]
        public string portOfOrigin1Delimiter { get; set; }

        [JsonProperty("totalVesselQuantity-Delimiter")]
        public string totalVesselQuantityDelimiter { get; set; }

        [JsonProperty("voyageNumber-RequireDecimal")]
        public string voyageNumberRequireDecimal { get; set; }

        [JsonProperty("portOfOrigin1-RequireDecimal")]
        public string portOfOrigin1RequireDecimal { get; set; }

        [JsonProperty("totalVesselQuantity-RequireDecimal")]
        public string totalVesselQuantityRequireDecimal { get; set; }

        [JsonProperty("voyageNumber-DecimalLimit")]
        public string voyageNumberDecimalLimit { get; set; }

        [JsonProperty("portOfOrigin1-DecimalLimit")]
        public string portOfOrigin1DecimalLimit { get; set; }

        [JsonProperty("totalVesselQuantity-DecimalLimit")]
        public string totalVesselQuantityDecimalLimit { get; set; }
        public int RowNo { get; set; }
    }


}
