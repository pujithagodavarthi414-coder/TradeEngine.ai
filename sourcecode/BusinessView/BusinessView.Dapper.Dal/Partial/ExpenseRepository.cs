using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Expenses;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class ExpenseRepository : BaseRepository
    {
        public Guid? UpsertMerchant(MerchantModel merchantModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MerchantId", merchantModel.MerchantId);
                    vParams.Add("@MerchantName", merchantModel.MerchantName);
                    vParams.Add("@Description", merchantModel.Description);
                    vParams.Add("@IsArchived", merchantModel.IsArchived);
                    vParams.Add("@TimeStamp", merchantModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertMerchant, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMerchant", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMerchantCouldNotBeCreated);
                return null;
            }
        }

        public List<MerchantModel> SearchMerchants(SearchMerchantApiInputModel searchMerchantApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MerchantId", searchMerchantApiInputModel.MerchantId);
                    vParams.Add("@MerchantName", searchMerchantApiInputModel.MerchantName);
                    vParams.Add("@IsArchived", searchMerchantApiInputModel.IsArchived);
                    vParams.Add("@Description", searchMerchantApiInputModel.Description);
                    vParams.Add("@SearchText", searchMerchantApiInputModel.SearchText);
                    vParams.Add("@SortBy", searchMerchantApiInputModel.SortBy);
                    vParams.Add("@SortDirection", searchMerchantApiInputModel.SortDirection);
                    vParams.Add("@PageSize", searchMerchantApiInputModel.PageSize);
                    vParams.Add("@PageNumber", searchMerchantApiInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MerchantModel>(StoredProcedureConstants.SpGetMerchants, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchMerchants", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchMerchants);
                return new List<MerchantModel>();
            }
        }

        public Guid? UpsertExpenseCategory(UpsertExpenseCategoryApiInputModel upsertExpenseCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseCategoryId", upsertExpenseCategoryApiInputModel.ExpenseCategoryId);
                    vParams.Add("@ExpenseCategoryName", upsertExpenseCategoryApiInputModel.ExpenseCategoryName);
                    vParams.Add("@AccountCode", upsertExpenseCategoryApiInputModel.AccountCode);
                    vParams.Add("@Description", upsertExpenseCategoryApiInputModel.Description);
                    vParams.Add("@IsSubCategory", upsertExpenseCategoryApiInputModel.IsSubCategory);
                    vParams.Add("@ImageUrl", upsertExpenseCategoryApiInputModel.ImageUrl);
                    vParams.Add("@IsActive", upsertExpenseCategoryApiInputModel.IsActive);
                    vParams.Add("@IsArchived", upsertExpenseCategoryApiInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertExpenseCategoryApiInputModel.Timestamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertExpenseCategory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseCategory", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpenseCategory);
                return null;
            }
        }

        public List<ExpenseCategoryModel> SearchExpenseCategories(ExpenseCategorySearchInputModel expenseCategorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseCategoryId", expenseCategorySearchInputModel.ExpenseCategoryId);
                    vParams.Add("@ExpenseCategoryName", expenseCategorySearchInputModel.CategoryName);
                    vParams.Add("@Description", expenseCategorySearchInputModel.Description);
                    vParams.Add("@AccountCode", expenseCategorySearchInputModel.AccountCode);
                    vParams.Add("@IsSubCategory", expenseCategorySearchInputModel.IsSubCategory);
                    vParams.Add("@IsArchived", expenseCategorySearchInputModel.IsArchived);
                    vParams.Add("@SearchText", expenseCategorySearchInputModel.SearchText);
                    vParams.Add("@SortBy", expenseCategorySearchInputModel.SortBy);
                    vParams.Add("@SortDirection", expenseCategorySearchInputModel.SortDirection);
                    vParams.Add("@PageSize", expenseCategorySearchInputModel.PageSize);
                    vParams.Add("@PageNumber", expenseCategorySearchInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExpenseCategoryModel>(StoredProcedureConstants.SpGetExpenseCategories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseCategories", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenseCategory);
                return new List<ExpenseCategoryModel>();
            }
        }

        public Guid? UpsertExpenseStatus(UpsertExpenseStatusModel upsertExpenseStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseStatusId", upsertExpenseStatusModel.Id);
                    vParams.Add("@Name", upsertExpenseStatusModel.Name);
                    vParams.Add("@Description", upsertExpenseStatusModel.Description);
                    vParams.Add("@IsArchived", upsertExpenseStatusModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertExpenseStatusModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertExpenseStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseStatus", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpenseStatus);
                return null;
            }
        }

        public List<ExpenseStatusModel> GetAllExpenseStatuses(ExpenseStatusSearchInputModel expenseStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseStatusId", expenseStatusSearchInputModel.ExpenseStatusId);
                    vParams.Add("@SearchText", expenseStatusSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", expenseStatusSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExpenseStatusModel>(StoredProcedureConstants.SpGetExpenseStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllExpenseStatuses", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenseStatuses);
                return new List<ExpenseStatusModel>();
            }
        }

        public Guid? UpsertExpenseReport(ExpenseReportInputModel expenseReportInputModel, string expensesXmlIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseReportId", expenseReportInputModel.ExpenseReportId);
                    vParams.Add("@ReportTitle", expenseReportInputModel.ReportTitle);
                    vParams.Add("@BusinessPurpose", expenseReportInputModel.BusinessPurpose);
                    vParams.Add("@DurationFrom", expenseReportInputModel.DurationFrom);
                    vParams.Add("@DurationTo", expenseReportInputModel.DurationTo);
                    vParams.Add("@ReportStatusId", expenseReportInputModel.ReportStatusId);
                    vParams.Add("@AdvancePayment", expenseReportInputModel.AdvancePayment);
                    vParams.Add("@AmountToBeReimbursed", expenseReportInputModel.AmountToBeReimbursed);
                    vParams.Add("@IsReimbursed", expenseReportInputModel.IsReimbursed);
                    vParams.Add("@UndoReimbursement", expenseReportInputModel.UndoReimbursement);
                    vParams.Add("@IsApproved", expenseReportInputModel.IsApproved);
                    vParams.Add("@IsArchived", expenseReportInputModel.IsArchived);
                    vParams.Add("@ReasonForApprovalOrRejection", expenseReportInputModel.ReasonForApprovalOrRejection);
                    vParams.Add("@ExpensesXmlIds", expensesXmlIds);
                    vParams.Add("@TimeStamp", expenseReportInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpCreateExpenseReport, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseReport", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpenseReport);
                return null;
            }
        }

        public Guid? UpsertExpenseReportStatus(UpsertExpenseReportStatusModel upsertExpenseReportStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseReportStatusId", upsertExpenseReportStatusModel.ExpenseReportStatusId);
                    vParams.Add("@Description", upsertExpenseReportStatusModel.Description);
                    vParams.Add("@Name", upsertExpenseReportStatusModel.Name);
                    vParams.Add("@IsArchived", upsertExpenseReportStatusModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertExpenseReportStatusModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertExpenseReportStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseReportStatus", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpenseReportStatus);
                return null;
            }
        }

        public List<ExpenseReportStatusModel> GetExpenseReportStatuses(ExpenseReportStatusSearchInputModel expenseReportStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseReportStatusId", expenseReportStatusSearchInputModel.ExpenseReportStatusId);
                    vParams.Add("@Description", expenseReportStatusSearchInputModel.Description);
                    vParams.Add("@Name", expenseReportStatusSearchInputModel.Name);
                    vParams.Add("@IsArchived", expenseReportStatusSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExpenseReportStatusModel>(StoredProcedureConstants.SpGetExpenseReportStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseReportStatuses", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenseReportStatuses);
                return new List<ExpenseReportStatusModel>();
            }
        }

        public List<SearchExpensesReportOutputModel> SearchExpenseReports(SearchExpenseReportsInputModel searchExpenseReportsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseReportId", searchExpenseReportsInputModel.ExpenseReportId);
                    vParams.Add("@DurationFrom", searchExpenseReportsInputModel.DurationFrom);
                    vParams.Add("@DurationTo", searchExpenseReportsInputModel.DurationTo);
                    vParams.Add("@ReportStatusId", searchExpenseReportsInputModel.ReportStatusId);
                    vParams.Add("@IsReimbursed", searchExpenseReportsInputModel.IsReimbursed);
                    vParams.Add("@IsApproved", searchExpenseReportsInputModel.IsApproved);
                    vParams.Add("@IsArchived", searchExpenseReportsInputModel.IsArchived);
                    vParams.Add("@SearchText", searchExpenseReportsInputModel.SearchText);
                    vParams.Add("@SortBy", searchExpenseReportsInputModel.SortBy);
                    vParams.Add("@SortDirection", searchExpenseReportsInputModel.SortDirection);
                    vParams.Add("@PageSize", searchExpenseReportsInputModel.PageSize);
                    vParams.Add("@PageNumber", searchExpenseReportsInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SearchExpensesReportOutputModel>(StoredProcedureConstants.SpSearchExpenseReports, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseReports", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenseReports);
                return new List<SearchExpensesReportOutputModel>();
            }
        }

        public List<Guid?> InsertMultipleExpenses(string expensesXmlModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpensesXmlModel", expensesXmlModel);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertExpenses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertMultipleExpenses", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertMultipleExpenses);
                return new List<Guid?>();
            }
        }

        public Guid? UpsertExpense(ExpenseUpsertInputModel expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseId", expenseUpsertInputModel.ExpenseId);
                    vParams.Add("@ExpenseName", expenseUpsertInputModel.ExpenseName);
                    vParams.Add("@ExpensesXmlModel", expenseUpsertInputModel.ExpensesXmlModel);
                    vParams.Add("@PaymentStatusId", expenseUpsertInputModel.PaymentStatusId);
                    vParams.Add("@CashPaidThroughId", expenseUpsertInputModel.CashPaidThroughId);
                    vParams.Add("@ExpenseReportId", expenseUpsertInputModel.ExpenseReportId);
                    vParams.Add("@ExpenseStatusId", expenseUpsertInputModel.ExpenseStatusId);
                    vParams.Add("@BillReceiptId", expenseUpsertInputModel.BillReceiptId);
                    vParams.Add("@ClaimReimbursement", expenseUpsertInputModel.ClaimReimbursement);
                    vParams.Add("@MerchantId", expenseUpsertInputModel.MerchantId);
                    vParams.Add("@ReceiptDate", expenseUpsertInputModel.ReceiptDate);
                    vParams.Add("@ExpenseDate", expenseUpsertInputModel.ExpenseDate);
                    vParams.Add("@RepliedByUserId", expenseUpsertInputModel.RepliedByUserId);
                    vParams.Add("@RepliedDateTime", expenseUpsertInputModel.RepliedDateTime);
                    vParams.Add("@Reason", expenseUpsertInputModel.Reason);
                    vParams.Add("@IsApproved", expenseUpsertInputModel.IsApproved);
                    vParams.Add("@IsArchived", expenseUpsertInputModel.IsArchived);
                    vParams.Add("@ClaimedByUserId", expenseUpsertInputModel.ClaimedByUserId);
                    vParams.Add("@ActualBudget", expenseUpsertInputModel.ActualBudget);
                    vParams.Add("@ReferenceNumber", expenseUpsertInputModel.ReferenceNumber);
                    vParams.Add("@CurrencyId", expenseUpsertInputModel.CurrencyId);
                    vParams.Add("@BranchId", expenseUpsertInputModel.BranchId);
                    vParams.Add("@TimeStamp", expenseUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertExpense, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpense", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpense);
                return null;
            }
        }

        public Guid? ApproveOrRejectExpense(ExpenseUpsertInputModel expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseId", expenseUpsertInputModel.ExpenseId);
                    vParams.Add("@IsApproved", expenseUpsertInputModel.IsApproved);
                    vParams.Add("@ExpenseStatusId", expenseUpsertInputModel.ExpenseStatusId);
                    vParams.Add("@IsArchived", expenseUpsertInputModel.IsArchived);
                    vParams.Add("@IsPaid", expenseUpsertInputModel.IsPaid);
                    vParams.Add("@TimeStamp", expenseUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpApproveorRejectExpense, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ApproveOrRejectExpense", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpense);
                return null;
            }
        }

        public List<ExpenseSpReturnModel> SearchExpenses(ExpenseSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseId", expenseSearchCriteriaInputModel.ExpenseId);
                    vParams.Add("@ExpenseCategoryId", expenseSearchCriteriaInputModel.ExpenseCategoryId);
                    vParams.Add("@PaymentStatusId", expenseSearchCriteriaInputModel.PaymentStatusId);
                    vParams.Add("@ClaimedByUserId", expenseSearchCriteriaInputModel.ClaimedByUserId);
                    vParams.Add("@ExpenseStatusId", expenseSearchCriteriaInputModel.ExpenseStatusId);
                    vParams.Add("@ClaimReimbursement", expenseSearchCriteriaInputModel.ClaimReimbursement);
                    vParams.Add("@MerchantId", expenseSearchCriteriaInputModel.MerchantId);
                    vParams.Add("@ExpenseDate", expenseSearchCriteriaInputModel.ExpenseDate);
                    vParams.Add("@IsArchived", expenseSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsMyExpenses", expenseSearchCriteriaInputModel.IsMyExpenses);
                    vParams.Add("@IsPendingExpenses", expenseSearchCriteriaInputModel.IsPendingExpenses);
                    vParams.Add("@IsApprovedExpenses", expenseSearchCriteriaInputModel.IsApprovedExpenses);
                    vParams.Add("@SearchText", expenseSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", expenseSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", expenseSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageSize", expenseSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", expenseSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@ExpenseDateFrom", expenseSearchCriteriaInputModel.ExpenseDateFrom);
                    vParams.Add("@ExpenseDateTo", expenseSearchCriteriaInputModel.ExpenseDateTo);
                    vParams.Add("@DateFrom", expenseSearchCriteriaInputModel.CreatedDateTimeFrom);
                    vParams.Add("@DateTo", expenseSearchCriteriaInputModel.CreatedDateTimeTo);
                    vParams.Add("@BranchId", expenseSearchCriteriaInputModel.BranchId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExpenseSpReturnModel>(StoredProcedureConstants.SpSearchExpense, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenses", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenses);
                return new List<ExpenseSpReturnModel>();
            }
        }

        public ExpensesReportSummaryOutputModel GetExpenseReportSummary(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExpensesReportSummaryOutputModel>(StoredProcedureConstants.SpGetExpenseReportSummary, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseReportSummary", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetExpenseReportSummary);
                return null;
            }
        }

        public List<ExpenseHistoryModel> SearchExpenseHistory(ExpenseHistoryModel expenseHistorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseHistoryId", expenseHistorySearchCriteriaInputModel.ExpenseHistoryId);
                    vParams.Add("@ExpenseId", expenseHistorySearchCriteriaInputModel.ExpenseId);
                    vParams.Add("@OldValue", expenseHistorySearchCriteriaInputModel.OldValue);
                    vParams.Add("@NewValue", expenseHistorySearchCriteriaInputModel.NewValue);
                    vParams.Add("@FieldName", expenseHistorySearchCriteriaInputModel.FieldName);
                    vParams.Add("@Description", expenseHistorySearchCriteriaInputModel.Description);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExpenseHistoryModel>(StoredProcedureConstants.SpSearchExpenseHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseHistory", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenses);
                return new List<ExpenseHistoryModel>();
            }
        }

        public List<ExpenseExcelModel> SearchExpensesDownloadDetails(ExpenseSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ExpenseId", expenseSearchCriteriaInputModel.ExpenseId);
                    vParams.Add("@ExpenseIdList", expenseSearchCriteriaInputModel.ExpenseIdList);
                    vParams.Add("@BranchId", expenseSearchCriteriaInputModel.BranchId);
                    vParams.Add("@ClaimedByUserId", expenseSearchCriteriaInputModel.ClaimedByUserId);
                    vParams.Add("@IsArchived", expenseSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@ExpenseDateFrom", expenseSearchCriteriaInputModel.ExpenseDateFrom);
                    vParams.Add("@ExpenseDateTo", expenseSearchCriteriaInputModel.ExpenseDateTo);
                    vParams.Add("@DateFrom", expenseSearchCriteriaInputModel.CreatedDateTimeFrom);
                    vParams.Add("@DateTo", expenseSearchCriteriaInputModel.CreatedDateTimeTo);
                    return vConn.Query<ExpenseExcelModel>(StoredProcedureConstants.SpExpenseDownloadDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpensesDownloadDetails", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenses);
                return new List<ExpenseExcelModel>();
            }
        }

        public List<ExpenseStatusSearchCriteriaInputModel> SearchExpenseStatuses(ExpenseStatusSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseStatusId", expenseSearchCriteriaInputModel.ExpenseStatusId);
                    vParams.Add("@SearchText", expenseSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExpenseStatusSearchCriteriaInputModel>(StoredProcedureConstants.SpSearchExpenseStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseStatuses", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenses);
                return new List<ExpenseStatusSearchCriteriaInputModel>();
            }
        }

        public Guid? ApprovePendingExpenses(ExpenseStatusSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpApprovePendingExpenses, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ApprovePendingExpenses", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenses);
                return null;
            }
        }

        public List<ApprovedUserModel> GetApprovedUserMails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ApprovedUserModel>(StoredProcedureConstants.SpGetApprovedUserMails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetApprovedUserMails", "ExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchExpenses);
                return new List<ApprovedUserModel>();
            }
        }
    }
}
