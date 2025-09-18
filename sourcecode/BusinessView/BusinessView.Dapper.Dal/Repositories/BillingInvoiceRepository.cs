using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class BillingInvoiceRepository : BaseRepository
    {
        public Guid? UpsertInvoice(UpsertInvoiceInputModel upsertInvoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@InvoiceId", upsertInvoiceInputModel.InvoiceId);
                    vParams.Add("@ClientId", upsertInvoiceInputModel.ClientId);
                    vParams.Add("@CurrencyId", upsertInvoiceInputModel.CurrencyId);
                    vParams.Add("@InvoiceNumber", upsertInvoiceInputModel.InvoiceNumber);
                    vParams.Add("@InvoiceImageUrl", upsertInvoiceInputModel.InvoiceImageUrl);
                    vParams.Add("@Title", upsertInvoiceInputModel.InvoiceTitle);
                    vParams.Add("@PO", upsertInvoiceInputModel.PO);
                    vParams.Add("@IssueDate", upsertInvoiceInputModel.IssueDate);
                    vParams.Add("@DueDate", upsertInvoiceInputModel.DueDate);
                    vParams.Add("@Notes", upsertInvoiceInputModel.Notes);
                    vParams.Add("@Terms", upsertInvoiceInputModel.Terms);
                    vParams.Add("@Discount", upsertInvoiceInputModel.Discount);
                    vParams.Add("@TotalInvoiceAmount", upsertInvoiceInputModel.TotalInvoiceAmount);
                    vParams.Add("@InvoiceDiscountAmount", upsertInvoiceInputModel.InvoiceDiscountAmount);
                    vParams.Add("@SubTotalInvoiceAmount", upsertInvoiceInputModel.SubTotalInvoiceAmount);
                    vParams.Add("@AmountPaid", upsertInvoiceInputModel.AmountPaid);
                    vParams.Add("@DueAmount", upsertInvoiceInputModel.DueAmount);
                    vParams.Add("@InvoiceItems", upsertInvoiceInputModel.InvoiceItemsXml);
                    vParams.Add("@InvoiceTasks", upsertInvoiceInputModel.InvoiceTasksXml);
                    vParams.Add("@InvoiceGoals", upsertInvoiceInputModel.InvoiceGoalsXml);
                    vParams.Add("@InvoiceProjects", upsertInvoiceInputModel.InvoiceProjectsXml);
                    vParams.Add("@InvoiceTax", upsertInvoiceInputModel.InvoiceTaxXml);
                    vParams.Add("@IsArchived", upsertInvoiceInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertInvoiceInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInvoice, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInvoice", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertInvoice);
                return null;
            }
        }

        public List<InvoiceOutputModel> GetInvoices(InvoiceInputModel invoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceId", invoiceInputModel.InvoiceId);
                    vParams.Add("@ClientId", invoiceInputModel.ClientId);
                    vParams.Add("@BranchId", invoiceInputModel.BranchId);
                    vParams.Add("@SearchText", invoiceInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId.ToString());
                    vParams.Add("@IsArchived", invoiceInputModel.IsArchived);
                    vParams.Add("@SortBy", invoiceInputModel.SortBy);
                    vParams.Add("@SortDirection", invoiceInputModel.SortDirection);
                    vParams.Add("@PageNumber", invoiceInputModel.PageNumber);
                    vParams.Add("@PageSize", invoiceInputModel.PageSize);
                    return vConn.Query<InvoiceOutputModel>(StoredProcedureConstants.SpGetInvoices, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoices", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoices);
                return new List<InvoiceOutputModel>();
            }
        }

        public List<InvoiceHistoryModel> GetInvoiceHistory(InvoiceHistoryModel invoiceHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceId", invoiceHistoryModel.InvoiceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<InvoiceHistoryModel>(StoredProcedureConstants.SpGetInvoiceHistory, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceHistory", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceHistory);
                return new List<InvoiceHistoryModel>();
            }
        }

        public List<InvoiceStatusModel> GetInvoiceStatuses(InvoiceStatusModel invoiceStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceStatusId", invoiceStatusModel.InvoiceStatusId);
                    vParams.Add("@InvoiceStatusName", invoiceStatusModel.InvoiceStatusName);
                    vParams.Add("@InvoiceStatusColor", invoiceStatusModel.InvoiceStatusColor);
                    vParams.Add("@SearchText", invoiceStatusModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", invoiceStatusModel.IsArchived);
                    return vConn.Query<InvoiceStatusModel>(StoredProcedureConstants.SpGetInvoiceStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceStatuses", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceStatuses);
                return new List<InvoiceStatusModel>();
            }
        }

        public List<AccountTypeModel> GetAccountTypes(AccountTypeModel accountTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AccountTypeId", accountTypeModel.AccountTypeId);
                    vParams.Add("@AccountTypeName", accountTypeModel.AccountTypeName);
                    vParams.Add("@SearchText", accountTypeModel.SearchText);
                    vParams.Add("@IsArchived", accountTypeModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AccountTypeModel>(StoredProcedureConstants.SpGetAccountTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAccountTypes", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAccountTypes);
                return new List<AccountTypeModel>();
            }
        }

        public Guid? InsertInvoiceLogPayment(InvoicePaymentLogModel invoicePaymentLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceId", invoicePaymentLogModel.InvoiceId);
                    vParams.Add("@PaidAccountToId", invoicePaymentLogModel.PaidAccountToId);
                    vParams.Add("@PaymentMethodId", invoicePaymentLogModel.PaymentMethodId);
                    vParams.Add("@AmountPaid", invoicePaymentLogModel.Amount);
                    vParams.Add("@Date", invoicePaymentLogModel.Date);
                    vParams.Add("@ReferenceNumber", invoicePaymentLogModel.ReferenceNumber);
                    vParams.Add("@Notes", invoicePaymentLogModel.Notes);
                    vParams.Add("@SendReceiptTo", invoicePaymentLogModel.SendReceiptTo);
                    vParams.Add("@IsArchived", invoicePaymentLogModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertInvoiceLogPayment, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertInvoiceLogPayment", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertInvoiceLog);
                return null;
            }
        }

        public List<InvoiceGoalOutputModel> GetInvoiceGoals(InvoiceGoalInputModel invoiceGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceGoalId", invoiceGoalInputModel.InvoiceGoalId);
                    vParams.Add("@InvoiceId", invoiceGoalInputModel.InvoiceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", invoiceGoalInputModel.IsArchived);
                    return vConn.Query<InvoiceGoalOutputModel>("USP_GetInvoiceGoals", vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceGoals", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceGoals);
                return new List<InvoiceGoalOutputModel>();
            }
        }

        public List<InvoiceTasksOutputModel> GetInvoiceTasks(InvoiceTasksInputModel invoiceTasksInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceTaskId", invoiceTasksInputModel.InvoiceTaskId);
                    vParams.Add("@InvoiceId", invoiceTasksInputModel.InvoiceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", invoiceTasksInputModel.IsArchived);
                    return vConn.Query<InvoiceTasksOutputModel>("USP_GetInvoiceTasks", vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceTasks", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceTasks);
                return new List<InvoiceTasksOutputModel>();
            }
        }

        public List<InvoiceItemsOutputModel> GetInvoiceItems(InvoiceItemsInputModel invoiceItemsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceItemId", invoiceItemsInputModel.InvoiceItemId);
                    vParams.Add("@InvoiceId", invoiceItemsInputModel.InvoiceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", invoiceItemsInputModel.IsArchived);
                    return vConn.Query<InvoiceItemsOutputModel>("USP_GetInvoiceItems", vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceItems", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceItems);
                return new List<InvoiceItemsOutputModel>();
            }
        }

        public List<InvoiceProjectsOutputModel> GetInvoiceProjects(InvoiceProjectsInputModel invoiceProjectsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceProjectId", invoiceProjectsInputModel.InvoiceProjectId);
                    vParams.Add("@InvoiceId", invoiceProjectsInputModel.InvoiceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", invoiceProjectsInputModel.IsArchived);
                    return vConn.Query<InvoiceProjectsOutputModel>("USP_GetInvoiceProjects", vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceProjects", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceProjects);
                return new List<InvoiceProjectsOutputModel>();
            }
        }

        public List<InvoiceTaxOutputModel> GetInvoiceTax(InvoiceTaxInputModel invoiceTaxInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceTaxId", invoiceTaxInputModel.InvoiceTaxId);
                    vParams.Add("@InvoiceId", invoiceTaxInputModel.InvoiceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", invoiceTaxInputModel.IsArchived);
                    return vConn.Query<InvoiceTaxOutputModel>("USP_GetInvoiceTax", vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceTax", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceItems);
                return new List<InvoiceTaxOutputModel>();
            }
        }

        public List<Guid?> MultipleInvoiceDelete(MultipleInvoiceDeleteModel multipleInvoiceDeleteModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@InvoiceId", multipleInvoiceDeleteModel.InvoiceIdXml);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpMultipleInvoiceDelete, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MultipleInvoiceDelete", "BillingInvoiceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMultipleInvoiceDelete);
                return null;
            }
        }


        //public SendInvoiceEmailModel SendInvoiceEmail(Guid? invoiceId, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        using (var vConn = OpenConnection())
        //        {
        //            var vParams = new DynamicParameters();
        //            vParams.Add("@InvoiceId", invoiceId);
        //            return vConn.Query<SendInvoiceEmailModel>(StoredProcedureConstants.SpSendInvoiceEmail, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
        //        }
        //    }
        //    catch (SqlException sqlException)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendInvoiceEmail", "Billing Invoice Repository", sqlException));
        //        SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSendInvoiceEmail);
        //        return null;
        //    }
        //}

        //public List<GetClientInvoiceOutputModel> GetClientInvoice(ClientInvoiceSearchInputModel getClientInvoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        using (IDbConnection vConn = OpenConnection())
        //        {
        //            DynamicParameters vParams = new DynamicParameters();
        //            vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
        //            vParams.Add("@InvoiceId", getClientInvoiceInputModel.InvoiceId);
        //            vParams.Add("@BillToCustomerId", getClientInvoiceInputModel.ClientId);
        //            vParams.Add("@SearchText", getClientInvoiceInputModel.SearchText);
        //            vParams.Add("@IsArchived", getClientInvoiceInputModel.IsArchived);
        //            return vConn.Query<GetClientInvoiceOutputModel>(StoredProcedureConstants.SpGetClientInvoices, vParams, commandType: CommandType.StoredProcedure).ToList();
        //        }
        //    }
        //    catch (SqlException sqlException)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientInvoice", "InvoiceManagement Repository", sqlException));

        //        SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClientInvoice);

        //        return null;
        //    }
        //}

        //public List<GetClientProjectOutputModel> GetClientProjects(ClientProjectSearchInputModel getClientProjectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        using (IDbConnection vConn = OpenConnection())
        //        {
        //            DynamicParameters vParams = new DynamicParameters();
        //            vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
        //            vParams.Add("@BillToCustomerId", getClientProjectInputModel.ClientId);
        //            vParams.Add("@SearchText", getClientProjectInputModel.SearchText);
        //            return vConn.Query<GetClientProjectOutputModel>(StoredProcedureConstants.SpGetClientProjects, vParams, commandType: CommandType.StoredProcedure).ToList();
        //        }
        //    }

        //    catch (SqlException sqlException)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientProjects", "InvoiceManagement Repository", sqlException));

        //        SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClientProjects);

        //        return null;
        //    }
        //}

        //public List<GetInvoiceStatusOutputModel> GetInvoiceStatus(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        using (IDbConnection vConn = OpenConnection())
        //        {
        //            DynamicParameters vParams = new DynamicParameters();
        //            vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
        //            vParams.Add("@SearchText", searchText);
        //            return vConn.Query<GetInvoiceStatusOutputModel>(StoredProcedureConstants.SpGetInvoiceStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
        //        }
        //    }

        //    catch (SqlException sqlException)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceStatus", "InvoiceManagement Repository", sqlException));

        //        SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceStatus);

        //        return null;
        //    }
        //}

    }
}
