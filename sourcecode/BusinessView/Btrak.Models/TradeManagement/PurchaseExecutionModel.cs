using Btrak.Models.File;
using Btrak.Models.Lives;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class PurchaseExecutionModel
    {
        public Guid? Id { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? StepId { get; set; }
        public object OldData { get; set; }
        public object NewData { get; set; }
        public Guid? PurchaseId { get; set; }
        public List<Guid?> PurchaseIds { get; set; }
        public string StepName { get; set; }
        public string ContractName { get; set; }
        public string Comment { get; set; }
        public Guid? StatusId  { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? StampClientId { get; set; }
        public string ContractType { get; set; }
        public int ReminderCount { get; set; }
        public List<string> Documents { get; set; }
        public List<FileApiServiceReturnModel> Files { get; set; }
        public string ReferenceText { get; set; }
        public string ClientType { get; set; }
        public Guid? ClientTypeId { get; set; }
        public string StatusName { get; set; }
        public string RoutePath { get; set; }
        public string AcceptCommentsBySgTrader { get; set; }
        public string RejectCommentsBySgTrader { get; set; }
        public string SellerAcceptedComments { get; set; }
        public string SellerRejectedComments { get; set; }
        public string VesselOwnerAcceptedComments { get; set; }
        public string VesselOwnerRejectedComments { get; set; }
        public string AcceptedComments { get; set; }
        public bool? IsVesselOwner { get; set; }
        public bool? IsSeller { get; set; }
        public object FormData { get; set; }
        public List<DraftBlDetails> BlDraftForm { get; set; }
        public object StepHistory { get; set; }
        public object FormJson { get; set; }
        public Guid? TemplateId { get; set; }
        public bool IsUploadFile { get; set; }
        public bool IsSgtraderShared { get; set; }
        public bool IsSharedToSgtrader { get; set; }
        public bool IsApprovalNeededFromSgTrader { get; set; }
        public List<Guid?> UserIds { get; set; }
        public bool IsBrokerNeed { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public bool? IsFromSellerAcceptance { get; set; }
        public bool? IsFromVeseelOwnerAcceptance { get; set; }
        public bool? IsSharedToPortAgent { get; set; }
        public bool? IsSharedToSeller { get; set; }
        public bool? PdfGenerationForBlDraft { get; set; }
        public string ContractUrl { get; set; }
        public bool? IsGeneratePdf { get; set; }
        public bool? CanShowAlert { get; set; }
        public Guid? VesselId { get; set; }
        public object DataSourceFormJson { get; set; }
        public List<BuyerSwitchBlContractDetails> BlDetails { get; set; }
        public List<DocumentsShippingInstructionsModel> DocumentShippingInstructionsDetails { get; set; }
        public bool? IsFileReUploaded { get; set; }
        public string ReUploadedUrl { get; set; }
        public string StampDocument { get; set; }
        public string StampPdfURL{ get; set; }
        public bool? IsStepReInitiated { get; set; }
        public bool? IsPODStepShareOrRemind { get; set; }
        public List<Guid?> PODClientIds { get; set; }
        public List<Guid?> AcceptedBankers { get; set; }
        public List<Guid?> RejectedBankers { get; set; }
        public bool? IsStampNeeded { get; set; }
        public List<ShareClientModel> StatementOfAccountsHistory { get; set; }
        public List<ShareDocumentsHistoryModel> ShareDocumentsHistory { get; set; }
        public List<StepsURLsGetOuputModel> SharedDocuments { get; set; }
        public UserLevelAccessModel UserLevelAccessModel { get; set; }
    }

    public  class DocumentsShippingInstructionsModel
    {
        public Guid? TemplateId { get; set; }
        public object FormData { get; set; }
        public object FormJson { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public string ContractUrl { get; set; }
        public bool? IsGeneratePdf { get; set; }
        public string TemplateTypeName { get; set; }
        public string TemplateName { get;set; }
        public Guid? ClientId { get; set; }
        public string ReUploadedUrl { get; set; }
        public bool? IsFileReUploaded { get; set; }
        public bool? IsStampNeeded { get; set; }
    }
}
