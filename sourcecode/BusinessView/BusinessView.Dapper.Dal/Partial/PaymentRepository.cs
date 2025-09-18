using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using BTrak.Common;
using Dapper;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models.CurrencyConversion;
using Btrak.Models.PaymentMethod;
using Btrak.Models.Crm.Payment;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class PaymentRepository : BaseRepository
    {
        public Guid? UpsertPaymentMethod(PaymentMethodInputModel paymentMethodInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PaymentMethodId", paymentMethodInputModel.PaymentMethodId);
                    vParams.Add("@PaymentMethodName", paymentMethodInputModel.PaymentMethodName);
                    vParams.Add("@TimeStamp", paymentMethodInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", paymentMethodInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPaymentMethod, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentMethod", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public List<PaymentMethodOutputModel> GetPaymentMethod(PaymentMethodSearchCriteriaInputModel paymentMethodSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PaymentMethodId", paymentMethodSearchCriteriaInputModel.PaymentMethodId);
                    vParams.Add("@SearchText", paymentMethodSearchCriteriaInputModel.PaymentMethodNameSearchText);
                    vParams.Add("@IsArchived", paymentMethodSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PaymentMethodOutputModel>(StoredProcedureConstants.SpGetPaymentMethods, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPaymentMethod", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPaymentMethod);
                return new List<PaymentMethodOutputModel>();
            }
        }

        public Guid? UpsertCompanyPaymentMethod(CompanyPaymentUpsertInputModel companyPaymentInputModel, Guid? loggedInUserId,string siteAddress, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PaymentId", companyPaymentInputModel.PaymentId);
                    vParams.Add("@NoOfPurchases", companyPaymentInputModel.NoOfPurchases);
                    vParams.Add("@TotalAmount", companyPaymentInputModel.TotalAmount);
                    vParams.Add("@SubscriptionType", companyPaymentInputModel.SubscriptionType);
                    vParams.Add("@StripeTokenId", companyPaymentInputModel.StripeTokenId);
                    vParams.Add("@StripeCustomerId", companyPaymentInputModel.StripeCustomerId);
                    vParams.Add("@StripePaymentId", companyPaymentInputModel.StripePaymentId);
                    vParams.Add("@PricingId", companyPaymentInputModel.PricingId);
                    vParams.Add("@SubscriptionId", companyPaymentInputModel.SubscriptionId);
                    vParams.Add("@Status", companyPaymentInputModel.Status);
                    vParams.Add("@IsSubscriptionDone", companyPaymentInputModel.IsSubscriptionDone);
                    vParams.Add("@OperationsPerformedBy", loggedInUserId);
                    vParams.Add("@TimeStamp", companyPaymentInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@siteAddress", siteAddress);
                    vParams.Add("@PurchaseType", companyPaymentInputModel.PlanName);
                    vParams.Add("@IsUpdated", companyPaymentInputModel.IsUpdate);
                    vParams.Add("@CurrentPeriodEnd", companyPaymentInputModel.EndTime);
                    vParams.Add("@CurrentPeriodStart", companyPaymentInputModel.StartTime);
                    vParams.Add("@IsCancelled", companyPaymentInputModel.IsCancelled);
                    vParams.Add("@CancelAt", companyPaymentInputModel.CancelledDate);
                    vParams.Add("@CompanyId", companyPaymentInputModel.CompanyId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCompanyPayment, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentMethod", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }
        public string GetSubscriptionId(Guid? loggedInUserId, string siteAddress, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInUserId);
                    vParams.Add("@siteAddress", siteAddress);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetSubscriptionId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CancelSubscription", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public CompanyPaymentUpsertOutputModel GetPurchasedLicencesCount(Guid? loggedInUserId, string siteAddress, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInUserId);
                    vParams.Add("@siteAddress", siteAddress);
                    return vConn.Query<CompanyPaymentUpsertOutputModel>(StoredProcedureConstants.SpGetPurchasedLicencesCount, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPurchasedLicencesCount", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return new CompanyPaymentUpsertOutputModel();
            }
        }

        public Guid? CancelSubscription(CompanyPaymentUpsertInputModel subscriptionInputModel)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SubscriptionId", subscriptionInputModel.SubscriptionId);
                    vParams.Add("@CancelAt", subscriptionInputModel.CancelledDate);
                    vParams.Add("@CurrentPeriodEnd", subscriptionInputModel.EndTime);
                    vParams.Add("@CurrentPeriodStart", subscriptionInputModel.StartTime);
                    vParams.Add("@IsCancelled", subscriptionInputModel.IsCancelled);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpCancelSubscription, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CancelSubscription", "PaymentRepository", sqlException.Message), sqlException);
                return null;
            }
        }

        public List<CompanyPaymentUpsertInputModel> GetPaymentHistory(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CompanyPaymentUpsertInputModel>(StoredProcedureConstants.SpGetPaymentHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPaymentHistory", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return new List<CompanyPaymentUpsertInputModel>();
            }
        }

        public Guid? SaveBillingDetails(CompanyPaymentUpsertInputModel companyPaymentInputModel,List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StripeCustomerId", companyPaymentInputModel.StripeCustomerId);
                    vParams.Add("@SubscriptionId", companyPaymentInputModel.SubscriptionId);
                    vParams.Add("@Status", companyPaymentInputModel.Status);
                    vParams.Add("@IsSubscriptionDone", companyPaymentInputModel.IsSubscriptionDone);
                    vParams.Add("@InvoiceId", companyPaymentInputModel.InvoiceId);
                    vParams.Add("@IsRenewal", companyPaymentInputModel.IsRenewal);
                    vParams.Add("@PricingId", companyPaymentInputModel.PricingId);
                    vParams.Add("@TotalAmount", companyPaymentInputModel.TotalAmount);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBillingDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentMethod", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public Guid? UpdateInvoiceId(CompanyPaymentUpsertInputModel companyPaymentInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SubscriptionId", companyPaymentInputModel.SubscriptionId);
                    vParams.Add("@InvoiceId", companyPaymentInputModel.InvoiceId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInvoiceId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateInvoiceId", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public CompanyPaymentUpsertOutputModel GetPaymentDetailsWithSubscriptionId(string subscriptionId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@subscriptionId", subscriptionId);
                    return vConn.Query<CompanyPaymentUpsertOutputModel>(StoredProcedureConstants.SpGetPaymentDetailsWithSubscriptionId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPaymentId", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }
        public List<string> GetAllSubscriptionIds(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetSubscriptionIds, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllSubscriptionIds", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return new List<string>();
            }
        }
        public List<string> GetAllCustomerIds(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetAllCustomerIds, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllCustomerIds", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return new List<string>();
            }
        }
        public Guid? UpdateCRMPaymentDetails(PaymentInputModel paymentInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PaymentId", paymentInputModel.PaymentId);
                    vParams.Add("@ReceiverId", paymentInputModel.ReceiverId);
                    vParams.Add("@PaymentType", paymentInputModel.PaymentType.ToString());
                    vParams.Add("@AmountDue", paymentInputModel.AmountDue);
                    vParams.Add("@AmountPaid", paymentInputModel.AmountPaid);
                    vParams.Add("@ChequeNumber", paymentInputModel.ChequeNumber);
                    vParams.Add("@BankName", paymentInputModel.BankName);
                    vParams.Add("@BenificiaryName", paymentInputModel.BenificiaryName);
                    vParams.Add("@PaidBy", paymentInputModel.PaidBy);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCRMPayment, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentMethod", "PaymentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

    }
}
