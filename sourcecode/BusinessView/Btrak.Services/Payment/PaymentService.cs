using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Crm.Payment;
using Btrak.Services.Helpers.CompanyLocationValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web;

namespace Btrak.Services.Payment
{
    public class PaymentService : IPaymentService
    {
        private readonly PaymentRepository _paymentRepository;
        public PaymentService(PaymentRepository paymentRepository)
        {
            _paymentRepository = paymentRepository;
        }

        public Guid? UpsertCompanyPayment(CompanyPaymentUpsertInputModel companyPaymentInputModel, Guid? loggedInUserId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyPayment", "companyPaymentInputModel", companyPaymentInputModel, "Company Payment Service"));

            var url = HttpContext.Current.Request.Url.Authority;

            var splits = url.Split('.');
            companyPaymentInputModel.PaymentId = _paymentRepository.UpsertCompanyPaymentMethod(companyPaymentInputModel, loggedInUserId, splits[0], validationMessages);

            LoggingManager.Debug("Company Payment with the id " + companyPaymentInputModel?.PaymentId);
            return companyPaymentInputModel.PaymentId;
        }
        public string GetSubscriptionId(Guid? loggedInUserId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyPayment", "companyPaymentInputModel", "", "Company Payment Service"));

            var url = HttpContext.Current.Request.Url.Authority;

            var splits = url.Split('.');
            var subscriptionId = _paymentRepository.GetSubscriptionId(loggedInUserId, splits[0], validationMessages);

            LoggingManager.Debug("Cancel subscription with the id " + subscriptionId);
            return subscriptionId;
        }

        public CompanyPaymentUpsertOutputModel GetPurchasedLicencesCount(Guid? loggedInUserId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPurchasedLicencesCount", "GetPurchasedLicencesCount", "", "Company Payment Service"));

            var url = HttpContext.Current.Request.Url.Authority;

            var splits = url.Split('.');
            var purchasedObj = _paymentRepository.GetPurchasedLicencesCount(loggedInUserId, splits[0], validationMessages);

            return purchasedObj;
        }

        public Guid? CancelSubscription(CompanyPaymentUpsertInputModel subscriptionInputModel)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CancelSubscription", "CancelSubscription", subscriptionInputModel, "Company Payment Service"));

            var cancelSubscriptionId = _paymentRepository.CancelSubscription(subscriptionInputModel);
            return cancelSubscriptionId;
        }
        public List<CompanyPaymentUpsertInputModel> GetPaymentHistory(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPaymentHistory", "GetPaymentHistory", "", "Company Payment Service"));
            return _paymentRepository.GetPaymentHistory(loggedInContext, validationMessages);
        }
        public Guid? SaveBillingDetails(CompanyPaymentUpsertInputModel companyPaymentInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SaveBillingDetails", "companyPaymentInputModel", companyPaymentInputModel, "Company Payment Service"));

            companyPaymentInputModel.PaymentId = _paymentRepository.SaveBillingDetails(companyPaymentInputModel, validationMessages);

            LoggingManager.Debug("Company Payment with the id " + companyPaymentInputModel?.PaymentId);
            return companyPaymentInputModel?.PaymentId;
        }
        public Guid? UpdateInvoiceId(CompanyPaymentUpsertInputModel companyPaymentInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateInvoiceId", "companyPaymentInputModel", companyPaymentInputModel, "Company Payment Service"));

            companyPaymentInputModel.PaymentId = _paymentRepository.UpdateInvoiceId(companyPaymentInputModel, validationMessages);

            LoggingManager.Debug("Company Payment with the id " + companyPaymentInputModel?.PaymentId);
            return companyPaymentInputModel?.PaymentId;
        }

        public CompanyPaymentUpsertOutputModel GetPaymentDetailsWithSubscriptionId(string subscriptionId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPaymentDetailsWithSubscriptionId", "SubscriptionId", subscriptionId, "Company Payment Service"));
            return _paymentRepository.GetPaymentDetailsWithSubscriptionId(subscriptionId, validationMessages);
        }
        public List<string> GetAllSubscriptionIds(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllSubscriptionIds", "GetAllSubscriptionIds", "", "Company Payment Service"));
            return _paymentRepository.GetAllSubscriptionIds(loggedInContext, validationMessages);
        }
        public List<string> GetAllCustomerIds(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllCustomerIds", "GetAllCustomerIds", "", "Company Payment Service"));
            return _paymentRepository.GetAllCustomerIds(loggedInContext, validationMessages);
        }

        public Guid? UpdateCRMPayment(PaymentInputModel paymentInputModel, LoggedInContext loggedInUserId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateCRMPayment", "paymentInputModel", paymentInputModel, "Company Payment Service"));

            paymentInputModel.PaymentId = _paymentRepository.UpdateCRMPaymentDetails(paymentInputModel, loggedInUserId, validationMessages);

            LoggingManager.Debug("Company location with the id " + paymentInputModel?.PaymentId);
            return paymentInputModel.PaymentId;
        }
    }
}
