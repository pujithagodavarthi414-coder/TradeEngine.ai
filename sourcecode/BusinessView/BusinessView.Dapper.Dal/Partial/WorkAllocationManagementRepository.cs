using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.MyWork;
using Btrak.Models.Work;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Partial
{
    public class WorkAllocationManagementRepository : BaseRepository
    {
        public List<WorkAllocationApiReturnModel> GetEmployeeWorkAllocation(WorkAllocationSearchCriteriaInputModel workAllocationSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy ", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", workAllocationSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", workAllocationSearchCriteriaInputModel.DateTo);
                    vParams.Add("@BranchId", workAllocationSearchCriteriaInputModel.BranchId);
                    vParams.Add("@ProjectId", workAllocationSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@TeamLeadId", workAllocationSearchCriteriaInputModel.TeamLeadId);
                    vParams.Add("@UserId", workAllocationSearchCriteriaInputModel.UserId);
                    vParams.Add("@SearchText", workAllocationSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", workAllocationSearchCriteriaInputModel.SortBy);
                    vParams.Add("@PageNumber", workAllocationSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", workAllocationSearchCriteriaInputModel.PageSize);
                    vParams.Add("@EntityId", workAllocationSearchCriteriaInputModel.EntityId);
                    vParams.Add("@IsAll", workAllocationSearchCriteriaInputModel.IsAll);
                    vParams.Add("@IsReportingOnly", workAllocationSearchCriteriaInputModel.IsReportingOnly);
                    vParams.Add("@IsMyself", workAllocationSearchCriteriaInputModel.IsMyself);
                    return vConn.Query<WorkAllocationApiReturnModel>(StoredProcedureConstants.SpGetEmployeeWorkAllocationForIndividualNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeWorkAllocation", "WorkAllocationManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeWorkAllocation);
                return new List<WorkAllocationApiReturnModel>();
            }
        }

        public List<UserHistoricalWorkReportSearchSpOutputModel> GetDrillDownUserStoryDetailsByUserId(WorkAllocationSearchCriteriaInputModel workAllocationSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy ", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", workAllocationSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", workAllocationSearchCriteriaInputModel.DateTo);
                    vParams.Add("@BranchId", workAllocationSearchCriteriaInputModel.BranchId);
                    vParams.Add("@ProjectId", workAllocationSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@TeamLeadId", workAllocationSearchCriteriaInputModel.TeamLeadId);
                    vParams.Add("@UserId", workAllocationSearchCriteriaInputModel.UserId);
                    vParams.Add("@SearchText", workAllocationSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", workAllocationSearchCriteriaInputModel.SortBy);
                    vParams.Add("@PageNumber", workAllocationSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", workAllocationSearchCriteriaInputModel.PageSize);
                    vParams.Add("@EntityId", workAllocationSearchCriteriaInputModel.EntityId);
                    return vConn.Query<UserHistoricalWorkReportSearchSpOutputModel>(StoredProcedureConstants.SpGetDrillDownUserStoryByUserId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDrillDownUserStoryDetailsByUserId", "WorkAllocationManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeWorkAllocation);
                return new List<UserHistoricalWorkReportSearchSpOutputModel>();
            }
        }
    }
}
