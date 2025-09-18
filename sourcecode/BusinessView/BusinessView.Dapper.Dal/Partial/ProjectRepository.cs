using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Projects;
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
    public partial class ProjectRepository
    {
        public Guid? UpsertProject(ProjectUpsertInputModel projectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectInputModel.ProjectId);
                    vParams.Add("@TimeZone", projectInputModel.TimeZone);
                    vParams.Add("@ProjectName", projectInputModel.ProjectName);
                    vParams.Add("@ProjectResponsiblePersonId", projectInputModel.ProjectResponsiblePersonId);
                    vParams.Add("@IsArchived", projectInputModel.IsArchived);
                    vParams.Add("@ProjectStatusColor", projectInputModel.ProjectStatusColor);
                    vParams.Add("@ProjectTypeId", projectInputModel.ProjectTypeId);
                    vParams.Add("@IsDateTimeConfiguration", projectInputModel.IsDateTimeConfiguration);
                    vParams.Add("@IsSprintsConfiguration", projectInputModel.IsSprintsConfiguration);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectStartDate", projectInputModel.ProjectStartDate);
                    vParams.Add("@ProjectEndDate", projectInputModel.ProjectEndDate);
                    vParams.Add("@TimeStamp", projectInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProject, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertProject);
                return null;
            }
        }

        public List<ProjectApiReturnModel> SearchProjects(ProjectSearchCriteriaInputModel projectSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@ProjectName", projectSearchCriteriaInputModel.ProjectName);
                    vParams.Add("@ProjectResponsiblePersonId", projectSearchCriteriaInputModel.ProjectResponsiblePersonId);
                    vParams.Add("@IsArchived", projectSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@ArchivedDateTime", projectSearchCriteriaInputModel.ArchivedDateTime);
                    vParams.Add("@ProjectStatusColor", projectSearchCriteriaInputModel.ProjectStatusColor);
                    vParams.Add("@SearchText", projectSearchCriteriaInputModel.SearchText);
                    vParams.Add("@ProjectTypeId", projectSearchCriteriaInputModel.ProjectTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNo", projectSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", projectSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", projectSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", projectSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@ProjectsIdsXml", projectSearchCriteriaInputModel.ProjectIdsXml);
                    vParams.Add("@ProjectSearchFilter", projectSearchCriteriaInputModel.ProjectSearchFilter);
                    return vConn.Query<ProjectApiReturnModel>(StoredProcedureConstants.SpSearchProjectsNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchProjects", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchProjects);
                return new List<ProjectApiReturnModel>();
            }
        }

        public ProjectOverViewApiReturnModel GetProjectOverViewDetails(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProjectOverViewApiReturnModel>(StoredProcedureConstants.SpGetGoalCountsBasedOnStatuses, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectOverViewDetails", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetProjectOverViewDetails);
                return null;
            }
        }

        public Guid? ArchiveProject(ArchiveProjectInputModel archiveProjectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", archiveProjectInputModel.ProjectId);
                    vParams.Add("@IsArchived", archiveProjectInputModel.IsArchive);
                    vParams.Add("@TimeZone", archiveProjectInputModel.TimeZone);
                    vParams.Add("@TimeStamp", archiveProjectInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteProject, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveProject", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionArchiveProject);
                return null;
            }
        }

        public Guid? UpsertProjectTags(ProjectTagUpsertInputModel projectTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectTagUpsertInputModel.ProjectId);
                    vParams.Add("@Tags", projectTagUpsertInputModel.Tags);
                    vParams.Add("@TimeStamp", projectTagUpsertInputModel.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProjectTags, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectTags", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertProjectTags);
                return null;
            }
        }

        public List<ProjectTagApiReturnModel> SearchProjectTags(ProjectTagSearchInputModel projectTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectTagSearchInputModel.ProjectId);
                    vParams.Add("@Tag", projectTagSearchInputModel.Tag);
                    vParams.Add("@SearchText", projectTagSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProjectTagApiReturnModel>(StoredProcedureConstants.SpSearchProjectTags, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchProjectTags", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchProjectTags);
                return new List<ProjectTagApiReturnModel>();
            }
        }

        public List<ProjectDropDownReturnModel> GetProjectsDropDown(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProjectDropDownReturnModel>(StoredProcedureConstants.SpGetProjectsDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectsDropDown", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchProjects);
                return new List<ProjectDropDownReturnModel>();
            }
        }

        public List<CapacityPlanningReportModel> GetCapacityPlanningReport(CapacityPlanningReportModel capacityPlanningReportModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", capacityPlanningReportModel.UserId);
                    vParams.Add("@DateFrom", capacityPlanningReportModel.DateFrom);
                    vParams.Add("@DateFrom", capacityPlanningReportModel.DateTo);
                    return vConn.Query<CapacityPlanningReportModel>(StoredProcedureConstants.SpGetCapacityPlanningReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectsDropDown", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchProjects);
                return new List<CapacityPlanningReportModel>();
            }
        }


        public List<ResourceUsageReportModel> GetResourceUsageReport(ResourceUsageReportSearchInputModel resourceUsageReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var proc = string.Empty;
                if (resourceUsageReportSearchInputModel.isChartData == true)
                {
                     proc = StoredProcedureConstants.SpGetResourceUsageChart;
                }
                else
                {
                    proc = StoredProcedureConstants.SpGetResourceUsageReport;
                }


                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserIds", resourceUsageReportSearchInputModel.UserIds);
                    vParams.Add("@ProjectIds", resourceUsageReportSearchInputModel.ProjectIds);
                    vParams.Add("@GoalIds", resourceUsageReportSearchInputModel.GoalIds);
                    vParams.Add("@DateFrom", resourceUsageReportSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", resourceUsageReportSearchInputModel.DateTo);
                    vParams.Add("@SortBy", resourceUsageReportSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", resourceUsageReportSearchInputModel.SortDirection);
                    vParams.Add("@PageNo", resourceUsageReportSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", resourceUsageReportSearchInputModel.PageSize);
                    return vConn.Query<ResourceUsageReportModel>(proc, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetResourceUsageReport", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetResourceUsageReport);
                return new List<ResourceUsageReportModel>();
            }
        }

        public List<ProjectUsageReportModel> GetProjectUsageReport(ProjectUsageReportSearchInputModel ProjectUsageReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {

                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserIds", ProjectUsageReportSearchInputModel.UserIds);
                    vParams.Add("@ProjectIds", ProjectUsageReportSearchInputModel.ProjectIds);
                    vParams.Add("@GoalIds", ProjectUsageReportSearchInputModel.GoalIds);
                    vParams.Add("@DateFrom", ProjectUsageReportSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", ProjectUsageReportSearchInputModel.DateTo);
                    vParams.Add("@SortBy", ProjectUsageReportSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", ProjectUsageReportSearchInputModel.SortDirection);
                    vParams.Add("@PageNo", ProjectUsageReportSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", ProjectUsageReportSearchInputModel.PageSize);
                    return vConn.Query<ProjectUsageReportModel>(StoredProcedureConstants.SpGetProjectUsageReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectUsageReport", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetProjectUsageReport);
                return new List<ProjectUsageReportModel>();
            }
        }
        public List<CumulativeWorkReportModel> GetCumulativeWorkReport(CumulativeWorkReportSearchInputModel CumulativeWorkReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {

                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", CumulativeWorkReportSearchInputModel.UserId);
                    vParams.Add("@ProjectId", CumulativeWorkReportSearchInputModel.ProjectId);
                    vParams.Add("@DateFrom", CumulativeWorkReportSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", CumulativeWorkReportSearchInputModel.DateTo);
                    vParams.Add("@Date", CumulativeWorkReportSearchInputModel.Date);
                 
                    return vConn.Query<CumulativeWorkReportModel>(StoredProcedureConstants.SpGetCumulativeWorkReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectUsageReport", "ProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCumulativeWorkReport);
                return new List<CumulativeWorkReportModel>();
            }
        }
    }
}
