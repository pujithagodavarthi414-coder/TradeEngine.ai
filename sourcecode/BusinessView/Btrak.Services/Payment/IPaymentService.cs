using Btrak.Models;
using Btrak.Models.Crm.Payment;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Payment
{
    public interface IPaymentService
    {
        Guid? UpsertCompanyPayment(CompanyPaymentUpsertInputModel companyPaymentInputModel,Guid ? loggedInUserId, List<ValidationMessage> validationMessages);
        string GetSubscriptionId(Guid? loggedInUserId, List<ValidationMessage> validationMessages);
        CompanyPaymentUpsertOutputModel GetPurchasedLicencesCount(Guid? loggedInUserId, List<ValidationMessage> validationMessages);
        Guid? CancelSubscription(CompanyPaymentUpsertInputModel subscriptionInputModel);
        List<CompanyPaymentUpsertInputModel> GetPaymentHistory(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? SaveBillingDetails(CompanyPaymentUpsertInputModel companyPaymentInputModel, List<ValidationMessage> validationMessages);
        Guid? UpdateInvoiceId(CompanyPaymentUpsertInputModel companyPaymentInputModel, List<ValidationMessage> validationMessages);
        CompanyPaymentUpsertOutputModel GetPaymentDetailsWithSubscriptionId(string subscriptionId, List<ValidationMessage> validationMessages);
        List<string> GetAllSubscriptionIds(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<string> GetAllCustomerIds(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpdateCRMPayment(PaymentInputModel paymentInputModel, LoggedInContext loggedInUserId, List<ValidationMessage> validationMessages);
    }
}


