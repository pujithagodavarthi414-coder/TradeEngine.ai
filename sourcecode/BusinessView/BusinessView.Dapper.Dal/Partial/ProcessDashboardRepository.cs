using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Dashboard;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ProcessDashboardRepository
    {
        public List<ProcessDashboardApiReturnModel> SearchOnboardedGoals(string statusColor,Guid? entityId, Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StatusColor", statusColor);
                    vParams.Add("@EntityId", entityId);
                    vParams.Add("ProjectId", projectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProcessDashboardApiReturnModel>(StoredProcedureConstants.SpSearchOnboardedGoals, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchOnboardedGoals", "ProcessDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchOnboardedGoals);
                return new List<ProcessDashboardApiReturnModel>();
            }
        }

        public int? UpsertProcessDashboard(string goalsXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProcessDashboardModel", goalsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<int>(StoredProcedureConstants.SpSnapshotProcessDashboard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProcessDashboard", "ProcessDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertProcessDashboard);
                return null;
            }
        }

        public List<ProcessDashboardApiReturnModel> GetGoalsOverAllStatusByDashboardId(int? dashboardId, Guid? projectId, Guid? entityId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", dashboardId);
                    vParams.Add("@ProjectId", projectId);
                    vParams.Add("@EntityId", entityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProcessDashboardApiReturnModel>(StoredProcedureConstants.SpGetProcessDashboard, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalsOverAllStatusByDashboardId", "ProcessDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetGoalsOverAllStatusByDashboardId);
                return new List<ProcessDashboardApiReturnModel>();
            }
        }

        public int? GetLatestDashboardNumber(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    IEnumerable<int?> queryResult = vConn.Query<int?>(StoredProcedureConstants.SpGetLatestDashboardNumber, vParams, commandType: CommandType.StoredProcedure);
                    if (queryResult != null)
                    {
                        return queryResult.FirstOrDefault();
                    }

                    return 0;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLatestDashboardNumber", "ProcessDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetLatestDashboardNumber);
                return null;
            }
        }
        public List<ModuleTabModel> UpsertModuleTabsData(ModuleTabModel moduleTabModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ModuleId", moduleTabModel.ModuleId);
                    vParams.Add("@TabId", moduleTabModel.Id);
                    vParams.Add("@TabName", moduleTabModel.Name);
                    vParams.Add("@IsUpsert", moduleTabModel.IsUpsert);
                    return vConn.Query<ModuleTabModel>(StoredProcedureConstants.SpUpsertModuleTabsData, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLatestDashboardNumber", "ProcessDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetLatestDashboardNumber);
                return null;
            }
        }
    }
}