using Btrak.Dapper.Dal.Helpers;
using Btrak.Dapper.Dal.Models;
using Btrak.Models;
using Btrak.Models.Productivity;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ProductivityDashboardRepositary : BaseRepository
    {
        public void UpsertProductivityDashboardDetails(UsersByCompanyIdModel user, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", user.UserId);
                    vConn.Query(StoredProcedureConstants.SpProductivityDasboardJob, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Upsert Productivity DashboardDetails", "ProductivityDashboardRepositary", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserUpsert);
            }
        }
        public List<ProductivityOutputModel> GetProductivityDetails(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@RankbasedOn", productivityInputModel.RankBasedOn);
                    return vConn.Query<ProductivityOutputModel>(StoredProcedureConstants.SpProductivityDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Productivity details", "ProductivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }
        public List<ProductivityStatsOutputModel> GetProductivityandQualityStats(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProductivityStatsOutputModel>(StoredProcedureConstants.SpProductivityStats, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Productivity details", "ProductivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }

        public List<TrendInsightsReportOutputModel> GetTrendInsightsReport(TrendInsightsReportInputModel trendInsightsReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", trendInsightsReportInputModel.DateFrom);
                    vParams.Add("@DateTo", trendInsightsReportInputModel.DateTo);
                    vParams.Add("@Date", trendInsightsReportInputModel.Date);
                    vParams.Add("@FilterType", trendInsightsReportInputModel.Filtertype);
                    vParams.Add("@UserId", trendInsightsReportInputModel.UserId);
                    vParams.Add("@BranchId", trendInsightsReportInputModel.BranchId);
                    vParams.Add("@LinemanagerId", trendInsightsReportInputModel.LineManagerId);
                    vParams.Add("@RankbasedOn", trendInsightsReportInputModel.RankBasedOn);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TrendInsightsReportOutputModel>(StoredProcedureConstants.SpGetTrendInsightsReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Productivity details", "ProductivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }
        public List<NoOfBugsOutputModel> GetNoOfBugsDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                      DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<NoOfBugsOutputModel>(StoredProcedureConstants.SpGetNoOfBugsDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Productivity details", "ProductivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }
        public List<PlannedHoursDrillDownOutputModel> GetPlannedDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", productivityDrillDownInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityDrillDownInputModel.DateTo);
                    vParams.Add("@UserId", productivityDrillDownInputModel.UserId);
                    vParams.Add("@BranchId", productivityDrillDownInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityDrillDownInputModel.LineManagerId);
                    vParams.Add("@filterType", productivityDrillDownInputModel.filterType);
                    return vConn.Query<PlannedHoursDrillDownOutputModel>(StoredProcedureConstants.SpGetPlannedDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPlannedHoursDrillDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPlannedDetailsDrillDown);
                return null;
            }
        }
        public List<ProductivityDrillDownOutputModel> GetProductivityDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    return vConn.Query<ProductivityDrillDownOutputModel>(StoredProcedureConstants.SpProductivityDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductivityDrillDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetProductivityDrillDown);
                return null;
            }
        }
        public List<UtilizationOutputModel> GetUtilizationDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    return vConn.Query<UtilizationOutputModel>(StoredProcedureConstants.SpUtilizationDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUtilizationDrillDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUtilizationDrillDown);
                return null;
            }
        }
        public List<EfficiencyDrillDownOutputModel> GetEfficiencyDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    return vConn.Query<EfficiencyDrillDownOutputModel>(StoredProcedureConstants.SpEfficiencyDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEfficiencyDrillDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEfficiencyDrillDown);
                return null;
            }
        }
        public List<HrStatsOutputModel> GetHrStats(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<HrStatsOutputModel>(StoredProcedureConstants.SpGetHrStats, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Productivity details", "ProductivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }
        public List<NoOfBounceBacksOutputModel> GetNoOfBounceBacksDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<NoOfBounceBacksOutputModel>(StoredProcedureConstants.SpGetNoOfBounceBacksDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Productivity details", "ProductivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }
        public List<DeliveredHoursOutputModel> GetDeliveredDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", productivityDrillDownInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityDrillDownInputModel.DateTo);
                    vParams.Add("@UserId", productivityDrillDownInputModel.UserId);
                    vParams.Add("@BranchId", productivityDrillDownInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityDrillDownInputModel.LineManagerId);
                    vParams.Add("@filterType", productivityDrillDownInputModel.filterType);
                    return vConn.Query<DeliveredHoursOutputModel>(StoredProcedureConstants.SpGetDeliveredDetailsDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDeliveredDetailsDrillDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDeliveredHoursDrillDown);
                return null;
            }
        }
        public List<NoOfBounceBacksOutputModel> GetNoOfReplansDrillDown(ProductivityInputModel productivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", productivityInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityInputModel.DateTo);
                    vParams.Add("@Date", productivityInputModel.Date);
                    vParams.Add("@FilterType", productivityInputModel.Filtertype);
                    vParams.Add("@UserId", productivityInputModel.UserId);
                    vParams.Add("@BranchId", productivityInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityInputModel.LineManagerId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<NoOfBounceBacksOutputModel>(StoredProcedureConstants.SpGetNoOfReplansDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNoOfReplansDrillDown", "ProductivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }
        public List<SpentHoursDrillDownOutputModel> GetSpentHoursDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", productivityDrillDownInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityDrillDownInputModel.DateTo);
                    vParams.Add("@UserId", productivityDrillDownInputModel.UserId);
                    vParams.Add("@BranchId", productivityDrillDownInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityDrillDownInputModel.LineManagerId);
                    vParams.Add("@filterType", productivityDrillDownInputModel.filterType);
                    return vConn.Query<SpentHoursDrillDownOutputModel>(StoredProcedureConstants.SpGetSpentDetailsDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSpentHoursDetailsDrillDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSpentDetailsDrillDown);
                return null;
            }
        }
        public List<CompletedTasksDrillDownOutputModel> GetCompletedTasksDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", productivityDrillDownInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityDrillDownInputModel.DateTo);
                    vParams.Add("@UserId", productivityDrillDownInputModel.UserId);
                    vParams.Add("@BranchId", productivityDrillDownInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityDrillDownInputModel.LineManagerId);
                    vParams.Add("@filterType", productivityDrillDownInputModel.filterType);
                    return vConn.Query<CompletedTasksDrillDownOutputModel>(StoredProcedureConstants.SpGetCompletedDetailsDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompletedTasksDetailsDrillDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompletedDetailsDrillDown);
                return null;
            }
        }

        public List<PendingTasksDrillDownOutputModel> GetPendingTasksDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", productivityDrillDownInputModel.DateFrom);
                    vParams.Add("@DateTo", productivityDrillDownInputModel.DateTo);
                    vParams.Add("@UserId", productivityDrillDownInputModel.UserId);
                    vParams.Add("@BranchId", productivityDrillDownInputModel.BranchId);
                    vParams.Add("@LineManagerId", productivityDrillDownInputModel.LineManagerId);
                    vParams.Add("@filterType", productivityDrillDownInputModel.filterType);
                    return vConn.Query<PendingTasksDrillDownOutputModel>(StoredProcedureConstants.SpGetPendingDetailsDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPendingTasksDetailsDrillDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPendingTasksDetailsDrillDown);
                return null;
            }
        }
        public List<BranchMembersOutputModel> GetBranchMembers(BranchMembersInputModel branchMembersInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@BranchId", branchMembersInputModel.BranchId);
                    return vConn.Query<BranchMembersOutputModel>(StoredProcedureConstants.SpGetBranchMembersByLoggedUserId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBranchMembers", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBranchMembers);
                return null;
            }
        }
        public void UpsertProductivityDashboardDetailsMannual(UsersByCompanyIdModel user,ProductivityJobMannualModel productivityJobMannualModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", user.UserId);
                    vParams.Add("@Date", productivityJobMannualModel.Date);
                    vConn.Query(StoredProcedureConstants.SpProductivityDasboardJob, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Upsert Productivity DashboardDetails", "ProductivityDashboardRepositary", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserUpsert);
            }
        }
    }
}
