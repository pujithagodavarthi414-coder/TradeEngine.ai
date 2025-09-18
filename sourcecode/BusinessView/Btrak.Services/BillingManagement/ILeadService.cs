using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Models.PaymentMethod;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.BillingManagement
{
    public interface ILeadService
    {
        Guid? UpsertLeadTemplate(LeadTemplateUpsertInputModel leadTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeadTemplatesOutputReturnModel> SearchLeadTemplate(LeadTemplateSearchInputModel leadTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeadStagesSearchOutputModel> GetLeadStages(LeadStagesSearchInputModel leadTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLeadContractSubmissions(LeadContractSubmissionsInputModel leadContractSubmissionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeadContractSubmissionsOutputModel> GetLeadContractSubmissions(LeadContractSubmissionsSearchInputModel leadContractSubmissionsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPaymentTerm(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PaymentTermOutputModel> GetPaymentTerms(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PaymentTermOutputModel> GetPortDetails(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPortDetails(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ClientCreditsLedgerOutputModel> GetLeadPayments(Guid LeadId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLeadInvoice(ClientCreditsUpsertInputModel clientCreditsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertWhDetails(WhDetailsInputModel whDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool CloseLead(Guid? leadId,int IsClosed, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeadContractSubmissionsOutputModel> GetLeadById(Guid? leadId, Guid? UserId, List<ValidationMessage> validationMessages);
        List<PaymentTermOutputModel> GetConsigneeList(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertConsignee(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertConsigner(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PaymentTermOutputModel> GetConsignerList(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

    }
}
