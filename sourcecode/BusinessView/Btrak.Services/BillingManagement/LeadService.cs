using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Models.PaymentMethod;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.BillingManagementValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.BillingManagement
{
    public class LeadService : ILeadService
    {
        private readonly LeadTemplateRepository _leadTemplateRepository;
        private readonly IAuditService _auditService;

        public LeadService(LeadTemplateRepository leadTemplateRepository, IAuditService auditService)
        {
            _leadTemplateRepository = leadTemplateRepository;
            _auditService = auditService;
        }
        public List<LeadTemplatesOutputReturnModel> SearchLeadTemplate(LeadTemplateSearchInputModel leadTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchLeadTemplate", "Lead Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchProjectsCommandId, leadTemplateSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, leadTemplateSearchInputModel, validationMessages))
            {
                return null;
            }

            List<LeadTemplatesOutputReturnModel> leadTemplatesReturnModels = _leadTemplateRepository.SearchLeadTemplate(leadTemplateSearchInputModel, loggedInContext, validationMessages).ToList();

            return leadTemplatesReturnModels;
        }

        public Guid? UpsertLeadTemplate(LeadTemplateUpsertInputModel leadTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(leadTemplateUpsertInputModel.ToString());

            if (!LeadTemplateValidationHelper.ValidateUpsertLeadTemplate(leadTemplateUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? templateId = _leadTemplateRepository.UpsertLeadTemplate(leadTemplateUpsertInputModel, loggedInContext, validationMessages);
            
            LoggingManager.Debug("Lead template with the id " + leadTemplateUpsertInputModel.TemplateId + " has been updated to " + leadTemplateUpsertInputModel);

            return templateId;
        }

        public List<LeadStagesSearchOutputModel> GetLeadStages(LeadStagesSearchInputModel leadStagesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeadStages", "Lead Service"));

            _auditService.SaveAudit(AppCommandConstants.GetLeadStages, leadStagesSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, leadStagesSearchInputModel, validationMessages))
            {
                return null;
            }

            List<LeadStagesSearchOutputModel> leadStages = _leadTemplateRepository.GetLeadStages(leadStagesSearchInputModel, loggedInContext, validationMessages).ToList();

            return leadStages;
        }
        public Guid? UpsertLeadContractSubmissions(LeadContractSubmissionsInputModel leadContractSubmissionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(leadContractSubmissionsInputModel.ToString());

            if (!LeadTemplateValidationHelper.ValidateUpsertLeadContract(leadContractSubmissionsInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? Id = _leadTemplateRepository.UpsertLeadContractSubmissions(leadContractSubmissionsInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Lead Contract with the id " + leadContractSubmissionsInputModel.Id + " has been updated to " + leadContractSubmissionsInputModel);

            return Id;
        }

        public List<LeadContractSubmissionsOutputModel> GetLeadContractSubmissions(LeadContractSubmissionsSearchInputModel leadContractSubmissionsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeadContractSubmissions", "Lead Service"));

            _auditService.SaveAudit(AppCommandConstants.GetLeadContractSubmissions, leadContractSubmissionsSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, leadContractSubmissionsSearchInputModel, validationMessages))
            {
                return null;
            }

            List<LeadContractSubmissionsOutputModel> contracts = _leadTemplateRepository.GetLeadContractSubmissions(leadContractSubmissionsSearchInputModel, loggedInContext, validationMessages).ToList();

            return contracts;
        }
        public List<LeadContractSubmissionsOutputModel> GetLeadById(Guid? LeadId,Guid? UserId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeadById", "Lead Service"));

            List<LeadContractSubmissionsOutputModel> lead = _leadTemplateRepository.GetLeadById(LeadId, UserId, validationMessages).ToList();
            lead[0].ScoDate = Convert.ToDateTime(lead[0].ScoCreatedDateTime.ToString()).ToString("dd-MMM-yyyy").ToString();
            if(lead[0].WeighingSlipDate != null)
            {
                lead[0].WeighingSlipDate = Convert.ToDateTime(lead[0].WeighingSlipDate.ToString()).ToString("yyyy-MM-dd").ToString();
            }

            return lead;
        }

        public Guid? UpsertPaymentTerm(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(paymentTermInputModel.ToString());

            if (!LeadTemplateValidationHelper.UpsertPaymentTerm(paymentTermInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? Id = _leadTemplateRepository.UpsertPaymentTerm(paymentTermInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Payment term with the id " + paymentTermInputModel.Id + " has been updated to " + paymentTermInputModel);

            return Id;
        }

        public List<PaymentTermOutputModel> GetPaymentTerms(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPaymentTerms", "Lead Service"));

            _auditService.SaveAudit(AppCommandConstants.GetLeadContractSubmissions, paymentTermSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, paymentTermSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<PaymentTermOutputModel> paymentTerms = _leadTemplateRepository.GetPaymentTerms(paymentTermSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return paymentTerms;
        }
        public Guid? UpsertPortDetails(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(paymentTermInputModel.ToString());

            if (!LeadTemplateValidationHelper.UpsertPaymentTerm(paymentTermInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? Id = _leadTemplateRepository.UpsertPortDetails(paymentTermInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Port details with the id " + paymentTermInputModel.Id + " has been updated to " + paymentTermInputModel);

            return Id;
        }

        public List<PaymentTermOutputModel> GetPortDetails(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPortDetails", "Lead Service"));

            _auditService.SaveAudit(AppCommandConstants.GetLeadContractSubmissions, paymentTermSearchCriteriaInputModel, loggedInContext);

            //if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, paymentTermSearchCriteriaInputModel, validationMessages))
            //{
            //    return null;
            //}

            List<PaymentTermOutputModel> paymentTerms = _leadTemplateRepository.GetPortDetails(paymentTermSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return paymentTerms;
        }
        public Guid? UpsertLeadInvoice(ClientCreditsUpsertInputModel creditsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(creditsUpsertInputModel.ToString());

            if (!LeadTemplateValidationHelper.UpsertLeadInvoice(creditsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? Id = _leadTemplateRepository.UpsertLeadInvoice(creditsUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Lead invoice details with the id " + Id + " has been updated to " + creditsUpsertInputModel);

            return Id;
        }

        public List<ClientCreditsLedgerOutputModel> GetLeadPayments(Guid LeadId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeadPayments", "Lead Service"));

            _auditService.SaveAudit(AppCommandConstants.GetLeadContractSubmissions, LeadId, loggedInContext);

            List<ClientCreditsLedgerOutputModel> paymentTerms = _leadTemplateRepository.GetLeadPayments(LeadId, loggedInContext, validationMessages).ToList();

            return paymentTerms;
        }
        public bool CloseLead(Guid? LeadId, int isClosed, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CloseLead", "Lead Service"));

            if (!LeadTemplateValidationHelper.CloseLead(LeadId, loggedInContext, validationMessages))
            {
                return false;
            }

            bool closeLead = _leadTemplateRepository.CloseLead(LeadId, isClosed, loggedInContext, validationMessages);

            return closeLead;
        }
        
        public Guid? UpsertWhDetails(WhDetailsInputModel whDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CloseLead", "Lead Service"));

            Guid? LeadId = _leadTemplateRepository.UpsertWhDetails(whDetailsInputModel, loggedInContext, validationMessages);

            return LeadId;
        }
        public Guid? UpsertConsigner(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(paymentTermInputModel.ToString());

            
            Guid? Id = _leadTemplateRepository.UpsertConsigner(paymentTermInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("consigner with the id " + paymentTermInputModel.Id + " has been updated to " + paymentTermInputModel);

            return Id;
        }

        public Guid? UpsertConsignee(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(paymentTermInputModel.ToString());
             
            Guid? Id = _leadTemplateRepository.UpsertConsignee(paymentTermInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("consignee with the id " + paymentTermInputModel.Id + " has been updated to " + paymentTermInputModel);

            return Id;
        }
        public List<PaymentTermOutputModel> GetConsigneeList(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConsignerList", "Lead Service"));

            _auditService.SaveAudit(AppCommandConstants.GetLeadContractSubmissions, paymentTermSearchCriteriaInputModel, loggedInContext);

            List<PaymentTermOutputModel> paymentTerms = _leadTemplateRepository.GetConsigneeList(paymentTermSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return paymentTerms;
        }
        public List<PaymentTermOutputModel> GetConsignerList(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConsignerList", "Lead Service"));

            _auditService.SaveAudit(AppCommandConstants.GetLeadContractSubmissions, paymentTermSearchCriteriaInputModel, loggedInContext);

            List<PaymentTermOutputModel> paymentTerms = _leadTemplateRepository.GetConsignerList(paymentTermSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return paymentTerms;
        }
    }
}
