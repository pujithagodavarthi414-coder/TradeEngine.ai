using Btrak.Dapper.Dal.Models;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Models.File;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web;

namespace Btrak.Services.BillingManagement
{
    public interface IClientService
    {
        List<ClientOutputModel> GetClients(ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSCOStatus(LeadSubmissionsDetails clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertClient(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ClientSecondaryContactOutputModel> GetClientSecondaryContacts(ClientSecondaryContactsInputModel clientSecondaryContactInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertClientSecondaryContact(UpsertClientSecondaryContactModel upsertClientSecondaryContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ClientProjectsOutputModel> GetClientProjects(ClientProjectsInputModel clientProjectsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertClientProjects(UpsertClientProjectsModel upsertClientProjectsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> MultipleClientDelete(MultipleClientDeleteModel multipleClientDeleteModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ClientHistoryModel> GetClientHistory(ClientHistoryModel clientHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<FileResult>> ExportClient(HttpRequest httpRequest, ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<FileResult>> ImportClient(HttpRequest httpRequest, ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertClientKycConfiguration(ClientKycConfiguration kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ClientKycConfigurationOutputModel> GetClientKycConfiguration(ClientKycConfiguration kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ClientTypeOutputModel> GetClientTypes(ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPurchaseConfiguration(PurchaseConfigInputModel purchaseConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PurchaseConfigOutputModel> GetPurchaseConfiguration(PurchaseConfigInputModel purchaseConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ContractSubmissionDetails> GetContractSubmissions(ContractSubmissionDetails clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<string> UpsertSCOMailToClient(UpsertClientInputModel invoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSCOGeneration(SCOUpsertInputModel purchaseConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SCOGenerationsOutputModel> GetSCOGenerations(SCOGenerationSerachInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SCOGenerationsOutputModel> GetScoGenerationById(SCOGenerationSerachInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<string> SendSCOAcceptanceMail(List<SendSCOAcceptanceMailInputModel> sendSCOAcceptanceMailInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertProductList(MasterProduct masterProduct, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertMasterContractDetails(MasterContractInputModel masterContractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProductListOutPutModel> GetProductsList(MasterProduct masterProduct, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> ReSendKycEmail(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MasterContractOutputModel> GetMasterContractDetails(MasterContractInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserDbEntity> GetWareHoseUsers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertGrades(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertVessels(VesselModel vesselModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GradeOutputModel> GetAllGrades(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CreditLimitLogsModel> GetAllCreditLogs(CreditLimitLogsModel creditLimitLogsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MasterContractOutputModel> GetPurchaseContract(MasterContractInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPurchaseContract(MasterContractInputModel masterContractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertShipmentExecutions(PurchaseShipmentExecutionInputModel purchaseShipmentExecutionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PurchaseShipmentExecutionSearchOutputModel> GetShipmentExecutions(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertShipmentExecutionBL(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PurchaseShipmentExecutionBLSearchOutputModel> GetShipmentExecutionBLs(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<VesselModel> GetAllVessels(VesselModel VesselModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        PurchaseShipmentExecutionBLSearchOutputModel GetShipmentExecutionBLById(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertBlDescription(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? SendChaConfirmationMail(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PurchaseShipmentExecutionBLSearchOutputModel GetBlDescriptions(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLegalEntity(LegalEntityModel legalEntityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LegalEntityModel> GetAllLegalEntities(LegalEntityModel VesselModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ClientOutputModel> GetClientKycDetails(ClientInputModel clientInputModel, List<ValidationMessage> validationMessages);

        Guid? UpsertClientType(ClientTypeUpsertInputModel clientTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ReOrderClientType(ClientTypeUpsertInputModel clientTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ClientTypeOutputModel> GetClientTypesBasedOnRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ShipToAddressSearchOutputModel> GetShipToAddresses(ShipToAddressSearchInputModel shipToAddressSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertShipToAddress(ShipToAddressUpsertInputModel shipToAddressUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PurchaseShipmentExecutionBLSearchOutputModel GetDocumentsDescriptions(Guid referenceTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertDocumentsDescription(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertKycDetails(ClientKycSubmissionDetails ClientKycSubmissionDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCounterPartySettings(CounterPartySettingsModel CounterPartySettingsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CounterPartySettingsModel> GetCounterPartySettings(CounterPartySettingsModel CounterPartySettingsModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertKycStatus(KycFormStatusModel KycFormStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<KycFormStatusModel> GetAllkycStatus(KycFormStatusModel KycFormStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<KycFormHistoryModel> GetClientKycHistory(KycFormHistoryModel KycFormHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTemplateConfiguration(TemplateConfigurationModel TemplateConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmailTemplate(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmailTemplateModel> GetAllEmailTemplates(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmailTemplateModel> GetHtmlTagsById(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TemplateConfigurationModel> GetAllTemplateConfigurations(TemplateConfigurationModel TemplateConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertContractStatus(ContractStatusModel ContractStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ContractStatusModel> GetAllContractStatus(ContractStatusModel ContractStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertInvoiceStatus(ClientInvoiceStatus ClientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ClientInvoiceStatus> GetAllInvoiceStatus(ClientInvoiceStatus ClientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TradeContractTypesModel> GetTradeContractTypes(TradeContractTypesModel TradeContractTypesModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        void SendMailToKYCAlert();
        void SendKYCRemindMail();
        List<ClientInvoiceStatus> GetAllInvoicePaymentStatus(ClientInvoiceStatus clientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateClientContractTemplates(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}