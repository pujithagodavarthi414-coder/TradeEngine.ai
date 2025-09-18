using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.TradeManagement;
using System.Threading.Tasks;
using Btrak.Models.FormDataServices;
using Btrak.Models.BillingManagement;
using Microsoft.WindowsAzure.Storage.Blob;
using Btrak.Models.CompanyStructure;

namespace Btrak.Services.Trading
{
    public interface ITradingService
    {
        Task<Guid?> UpsertContractTemplate(ContractTemplateModel ContractTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ContractTemplateModel> GetContractTemplates(ContractTemplateModel ContractTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object GetFormDropdowns(string DropDownType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string Key = null, string KeyValue = null);
        Task<Guid?> UpsertContract(ContractModel ContractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Task<Guid?> UpsertVesselContract(ContractModel ContractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertSaleContract(ContractModel contractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertSwitchBlContract(SwitchBlContractModel switchBlContractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ContractModel> GetContracts(ContractModel ContractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RFQListContractModel> GetRFQListForVesselContracts(ContractModel ContractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FinalSwitchBlModel> GetSwitchBlContracts(SwitchBlContractModel switchBlContractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SwitchBlBuyerContractOutputModel GetSwitchBlBuyerContracts(SwitchBlBuyerContractInputModel switchBlBuyerContractInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PurchaseContractDraftBlDetails> GetPurchaseContractDraftBlDetails(PurchaseExecutionModel purchaseExecutionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTolerance(ToleranceModel ToleranceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ToleranceModel> GetAllTolerances(ToleranceModel ToleranceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);        
        Guid? UpsertPaymentCondition(PaymentConditionModel PaymentConditionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PaymentConditionModel> GetAllPaymentConditions(PaymentConditionModel PaymentConditionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TradeTemplateTypes> GetTradeTemplateTypes(TradeTemplateTypes TradeTemplateTypes, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertTradeTemplate(TradeTemplateModel TradeTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertRFQRequestAndSend(RFQRequestModel rFQRequestModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpdateRFQRequest(RFQRequestInputModel rFQRequestModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> ShareQ88Document(ShareQ88InputModel shareQ88InputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpdateQ88DocumentStatus(UpdateQ88InputModel updateQ88InputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TradeTemplateModel> GetTradeTemplates(TradeTemplateModel TradeTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<DataSetHistoryInputModel>> SearchContractHistory(Guid? contractId, string contractType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RFQStatusModel> GetAllRFQStatus(RFQStatusModel rFQStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertRFQStatus(RFQStatusModel rfqStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<VesselConfirmationStatusModel> GetAllVesselConfirmationStatus(VesselConfirmationStatusModel vesselConfirmationStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertVesselConfirmationStatus(VesselConfirmationStatusModel vesselConfirmationStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PortCategoryModel> GetAllPortCategory(PortCategorySearchInputModel portCategorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPortCategory(PortCategoryModel portCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UnsoldQTYEmailAlert();
        List<LinkedPurchasesOutputModel> GetLinkedPurchaseAndSales(ContractModel contractModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? SendPurchaseExecutionRemind(PurchaseExecutionModel purchaseExecution , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertXPSteps(PurchaseExecutionModel purchaseExecution, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PurchaseExecutionModel> GetXPSteps(PurchaseExecutionModel purchaseExecution, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? ShareBLDraft(PurchaseExecutionModel purchaseExecution, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
         Task<List<DataSetHistoryInputModel>> GetXPStepsHistory(Guid? dataSetId, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
         dynamic GetExecutionFormData(PurchaseExecutionModel purchaseExecution, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertFormExecution(PurchaseExecutionModel purchaseExecution, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<string> GeneratePdfofInvoiceSteps(PurchaseExecutionModel purchaseExecutionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateXPStepAlert(StepAlertUpdateModel stepAlertUpdateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        dynamic GetAccountsPayableAging(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        dynamic GetPayablesAgingByCounterparty(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        dynamic GetPurchaseContractStatus(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MarginWalkOutputModel> GetMarginWalk(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<StepsURLsGetOuputModel> GetExecutionStepsURLs(PurchaseExecutionModel purchaseExecution, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CommodityBrokerCostOutputModel> GetCommodityBrokerCost(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CommissionandCostOutputModel> GetCommissionandOtherCost(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AvergeMaginInForCPOOutputModel> GetAvergeMaginInForCPO(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CostsotherthanCommodityBrokerageOutputModel> GetCostsotherthanCommodityBrokerage(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetSalesOutputModel> GetSalesValue(DashboardAPIInputModel dashboardAPIInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CloudBlobDirectory SetupCompanyFileContainer(CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId, string storageAccountName);
    }
}
