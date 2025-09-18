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
    public class BillingEstimateRepository : BaseRepository
    {
        public Guid? UpsertEstimate(UpsertEstimateInputModel upsertEstimateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EstimateId", upsertEstimateInputModel.EstimateId);
                    vParams.Add("@ClientId", upsertEstimateInputModel.ClientId);
                    vParams.Add("@CurrencyId", upsertEstimateInputModel.CurrencyId);
                    vParams.Add("@EstimateNumber", upsertEstimateInputModel.EstimateNumber);
                    vParams.Add("@EstimateImageUrl", upsertEstimateInputModel.EstimateImageUrl);
                    vParams.Add("@Title", upsertEstimateInputModel.EstimateTitle);
                    vParams.Add("@PO", upsertEstimateInputModel.PO);
                    vParams.Add("@IssueDate", upsertEstimateInputModel.IssueDate);
                    vParams.Add("@DueDate", upsertEstimateInputModel.DueDate);
                    vParams.Add("@Notes", upsertEstimateInputModel.Notes);
                    vParams.Add("@Terms", upsertEstimateInputModel.Terms);
                    vParams.Add("@Discount", upsertEstimateInputModel.Discount);
                    vParams.Add("@TotalEstimateAmount", upsertEstimateInputModel.TotalEstimateAmount);
                    vParams.Add("@EstimateDiscountAmount", upsertEstimateInputModel.EstimateDiscountAmount);
                    vParams.Add("@SubTotalEstimateAmount", upsertEstimateInputModel.SubTotalEstimateAmount);
                    vParams.Add("@EstimateItems", upsertEstimateInputModel.EstimateItemsXml);
                    vParams.Add("@EstimateTasks", upsertEstimateInputModel.EstimateTasksXml);
                    vParams.Add("@EstimateGoals", upsertEstimateInputModel.EstimateGoalsXml);
                    vParams.Add("@EstimateProjects", upsertEstimateInputModel.EstimateProjectsXml);
                    vParams.Add("@EstimateTax", upsertEstimateInputModel.EstimateTaxXml);
                    vParams.Add("@IsArchived", upsertEstimateInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertEstimateInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEstimate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEstimate", "BillingEstimateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEstimate);
                return null;
            }
        }

        public List<EstimateOutputModel> GetEstimates(EstimateInputModel estimateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EstimateId", estimateInputModel.EstimateId);
                    vParams.Add("@ClientId", estimateInputModel.ClientId);
                    vParams.Add("@BranchId", estimateInputModel.BranchId);
                    vParams.Add("@SearchText", estimateInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId.ToString());
                    vParams.Add("@IsArchived", estimateInputModel.IsArchived);
                    vParams.Add("@SortBy", estimateInputModel.SortBy);
                    vParams.Add("@SortDirection", estimateInputModel.SortDirection);
                    vParams.Add("@PageNumber", estimateInputModel.PageNumber);
                    vParams.Add("@PageSize", estimateInputModel.PageSize);
                    return vConn.Query<EstimateOutputModel>(StoredProcedureConstants.SpGetEstimates, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {

                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEstimates", "BillingEstimateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEstimates);
                return new List<EstimateOutputModel>();
            }
        }

        public List<EstimateHistoryModel> GetEstimateHistory(EstimateHistoryModel estimateHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EstimateId", estimateHistoryModel.EstimateId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EstimateHistoryModel>(StoredProcedureConstants.SpGetEstimateHistory, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEstimateHistory", "BillingEstimateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEstimateHistory);
                return new List<EstimateHistoryModel>();
            }
        }

        public List<EstimateStatusModel> GetEstimateStatuses(EstimateStatusModel estimateStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EstimateStatusId", estimateStatusModel.EstimateStatusId);
                    vParams.Add("@EstimateStatusName", estimateStatusModel.EstimateStatusName);
                    vParams.Add("@EstimateStatusColor", estimateStatusModel.EstimateStatusColor);
                    vParams.Add("@SearchText", estimateStatusModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", estimateStatusModel.IsArchived);
                    return vConn.Query<EstimateStatusModel>(StoredProcedureConstants.SpGetEstimateStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEstimateStatuses", "BillingEstimateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEstimateStatuses);
                return new List<EstimateStatusModel>();
            }
        }
    }
}
