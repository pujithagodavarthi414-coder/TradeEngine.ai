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
    public class BillingExpenseRepository : BaseRepository
    {
        public Guid? UpsertExpenseCategory(UpsertExpenseCategoryInputModel upsertExpenseCategoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ExpenseCategoryId", upsertExpenseCategoryInputModel.ExpenseCategoryId);
                    //vParams.Add("@ExpenseId", upsertExpenseCategoryInputModel.ExpenseId);
                    vParams.Add("@CategoryName", upsertExpenseCategoryInputModel.CategoryName);
                    vParams.Add("@Description", upsertExpenseCategoryInputModel.Description);
                    vParams.Add("@IsArchived", upsertExpenseCategoryInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertExpenseCategoryInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertExpenseCategory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseCategory", "BillingExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpenseCategory);
                return null;
            }
        }

        public List<ExpenseCategoryOutputModel> GetExpenseCategories(ExpenseCategoryInputModel expenseCategoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseCategoryId", expenseCategoryInputModel.ExpenseCategoryId);
                    //vParams.Add("@ExpenseId", expenseCategoryInputModel.ExpenseId);
                    vParams.Add("@BranchId", expenseCategoryInputModel.BranchId);
                    vParams.Add("@SearchText", expenseCategoryInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", expenseCategoryInputModel.IsArchived);
                    vParams.Add("@PageNumber", expenseCategoryInputModel.PageNumber);
                    vParams.Add("@PageSize", expenseCategoryInputModel.PageSize);
                    vParams.Add("@SortBy", expenseCategoryInputModel.SortBy);
                    vParams.Add("@SortDirection", expenseCategoryInputModel.SortDirection);
                    return vConn.Query<ExpenseCategoryOutputModel>(StoredProcedureConstants.SpGetExpenseCategories, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseCategories", "BillingExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetExpenseCategories);
                return new List<ExpenseCategoryOutputModel>();
            }
        }

        public Guid? UpsertExpenseMerchant(UpsertExpenseMerchantInputModel upsertExpenseMerchantInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ExpenseMerchantId", upsertExpenseMerchantInputModel.ExpenseMerchantId);
                    vParams.Add("@ExpenseId", upsertExpenseMerchantInputModel.ExpenseId);
                    vParams.Add("@MerchantName", upsertExpenseMerchantInputModel.MerchantName);
                    vParams.Add("@IsArchived", upsertExpenseMerchantInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertExpenseMerchantInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertExpenseMerchant, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseMerchant", "BillingExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpenseMerchant);
                return null;
            }
        }

        public Guid? UpsertMerchantBankDetails(UpsertExpenseMerchantInputModel upsertExpenseMerchantInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@MerchantBankDetailsId", upsertExpenseMerchantInputModel.MerchantBankDetailsId);
                    vParams.Add("@ExpenseMerchantId", upsertExpenseMerchantInputModel.ExpenseMerchantId);
                    vParams.Add("@PayeeName", upsertExpenseMerchantInputModel.PayeeName);
                    vParams.Add("@BankName", upsertExpenseMerchantInputModel.BankName);
                    vParams.Add("@BranchName", upsertExpenseMerchantInputModel.BranchName);
                    vParams.Add("@AccountNumber", upsertExpenseMerchantInputModel.AccountNumber);
                    vParams.Add("@IFSCCode", upsertExpenseMerchantInputModel.IFSCCode);
                    vParams.Add("@SortCode", upsertExpenseMerchantInputModel.SortCode);
                    vParams.Add("@IsArchived", upsertExpenseMerchantInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertExpenseMerchantInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertMerchantBankDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMerchantBankDetails", "BillingExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertMerchantBankDetails);
                return null;
            }
        }

        public List<ExpenseMerchantOutputModel> GetExpenseMerchants(ExpenseMerchantInputModel expenseMerchantInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseMerchantId", expenseMerchantInputModel.ExpenseMerchantId);
                    vParams.Add("@ExpenseId", expenseMerchantInputModel.ExpenseId);
                    vParams.Add("@BranchId", expenseMerchantInputModel.BranchId);
                    vParams.Add("@SearchText", expenseMerchantInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", expenseMerchantInputModel.IsArchived);
                    vParams.Add("@PageNumber", expenseMerchantInputModel.PageNumber);
                    vParams.Add("@PageSize", expenseMerchantInputModel.PageSize);
                    vParams.Add("@SortBy", expenseMerchantInputModel.SortBy);
                    vParams.Add("@SortDirection", expenseMerchantInputModel.SortDirection);
                    return vConn.Query<ExpenseMerchantOutputModel>(StoredProcedureConstants.SpGetExpenseMerchants, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseMerchants", "BillingExpenseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetExpenseMerchants);
                return new List<ExpenseMerchantOutputModel>();
            }
        }
    }
}
