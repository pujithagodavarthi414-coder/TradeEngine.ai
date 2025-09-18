using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models;
using Btrak.Models.Audit;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class AuditRepository
    {
        public IList<TimesheetAuditModel> GetAudit(Guid userId, Guid featureId, Guid userStoryId, DateTime? dateFrom, DateTime? dateTo)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@FeatureId", featureId);
                vParams.Add("@UserStoryId", userStoryId);
                vParams.Add("@DateFrom", dateFrom);
                vParams.Add("@DateTo", dateTo);
                return vConn.Query<TimesheetAuditModel>(StoredProcedureConstants.SpGetTimesheetAudit, vParams, commandType: CommandType.StoredProcedure)
                    .ToList();
            }
        }

        public List<AuditHistoryModel> SearchAuditHistory(AuditSearchCriteriaInputModel auditSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", auditSearchCriteriaInputModel.UserId);
                    vParams.Add("@FeatureId", auditSearchCriteriaInputModel.FeatureId);
                    vParams.Add("@UserStoryId", auditSearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", auditSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", auditSearchCriteriaInputModel.DateTo);
                    vParams.Add("@SearchText", auditSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", auditSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", auditSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageNumber", auditSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", auditSearchCriteriaInputModel.PageSize);
                    return vConn.Query<AuditHistoryModel>(StoredProcedureConstants.SpGetEachAuditNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditHistory", " AuditRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchAuditHistory);
                return new List<AuditHistoryModel>();
            }
        }

        public void SaveAudit(AuditModel auditModel, LoggedInContext loggedInContext)
        {
            //try
            //{
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@AuditJson", auditModel.AuditJson);
                vParams.Add("@FeatureId", auditModel.FeatureId);
                vParams.Add("@IsOldAudit", auditModel.IsOldAudit);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                vConn.Execute(StoredProcedureConstants.SpInsertAudit, vParams, commandType: CommandType.StoredProcedure);
            }
            //}
            //catch (SqlException sqlException)
            //{
            //    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveAudit", "Audit Repository", sqlException));
            //    SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertAudit);
            //}
        }

        public List<Audit> GetAuditByBranch(AuditTimelineInputModel auditTimelineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@StartDate", auditTimelineInputModel.StartDate);
                    vParams.Add("@EndDate", auditTimelineInputModel.EndDate);
                    vParams.Add("@MultipleBranchIds", auditTimelineInputModel.BranchIdJSON);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectId", auditTimelineInputModel.ProjectId);
                    return vConn.Query<Audit>(StoredProcedureConstants.SpGetAuditsByBranch, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditByBranch", " AuditRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditsByBranch);
                return new List<Audit>();
            }
        }


        public List<AuditConductTimelineOutputModel> GetAuditConductTimeline(AuditTimelineInputModel auditTimelineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@StartDate", auditTimelineInputModel.StartDate);
                    vParams.Add("@EndDate", auditTimelineInputModel.EndDate);
                    vParams.Add("@MultipleAuditIds", auditTimelineInputModel.AuditIdJSON);
                    vParams.Add("@MultipleBranchIds", auditTimelineInputModel.BranchIdJSON);
                    vParams.Add("@ProjectId", auditTimelineInputModel.ProjectId);
                    vParams.Add("@BusinessUnitIds", auditTimelineInputModel.BusinessUnitIdsList);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditConductTimelineOutputModel>(StoredProcedureConstants.SpGetAuditConductTimeline, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditConductTimeline", " AuditRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditConductTimeline);
                return new List<AuditConductTimelineOutputModel>();
            }
        }
    }
}
