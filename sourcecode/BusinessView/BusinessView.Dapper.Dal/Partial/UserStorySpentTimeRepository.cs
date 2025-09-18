using Btrak.Models.UserStory;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserStorySpentTimeRepository
    {
        public Guid? InsertUserStoryLogTime(UserStorySpentTimeUpsertInputModel userStorySpentTimeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStorySpentTimeId", userStorySpentTimeUpsertInputModel.UserStorySpentTimeId);
                    vParams.Add("@UserStoryId", userStorySpentTimeUpsertInputModel.UserStoryId);
                    vParams.Add("@SpentTime", userStorySpentTimeUpsertInputModel.SpentTime);
                    vParams.Add("@Comment", userStorySpentTimeUpsertInputModel.Comment);
                    vParams.Add("@DateFrom ", userStorySpentTimeUpsertInputModel.DateFrom);
                    vParams.Add("@DateTo", userStorySpentTimeUpsertInputModel.DateTo);
                    vParams.Add("@RemainingEstimateTypeId", userStorySpentTimeUpsertInputModel.LogTimeOptionId);
                    vParams.Add("@RemainingTimeSetOrReducedBy", userStorySpentTimeUpsertInputModel.RemainingTimeSetOrReducedBy);
                    vParams.Add("@IsArchived", userStorySpentTimeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", userStorySpentTimeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@StartTime", userStorySpentTimeUpsertInputModel.StartTime);
                    vParams.Add("@EndTime", userStorySpentTimeUpsertInputModel.EndTime);
                    vParams.Add("@BreakType", userStorySpentTimeUpsertInputModel.BreakType);
                    vParams.Add("@TimeZone", userStorySpentTimeUpsertInputModel.TimeZone);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStorySpentTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertUserStoryLogTime", "UserStorySpentTimeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertUserStoryLogTime);
                return null;
            }
        }

        public List<UserStorySpentTimeApiReturnModel> SearchUserStoryLogTime(UserStorySpentTimeSearchCriteriaInputModel userStorySpentTimeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStorySpentTimeId", userStorySpentTimeSearchCriteriaInputModel.UserStorySpentTimeId);
                    vParams.Add("@UserStoryId", userStorySpentTimeSearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@UserId", userStorySpentTimeSearchCriteriaInputModel.UserId);
                    vParams.Add("@SpentTime", userStorySpentTimeSearchCriteriaInputModel.SpentTime);
                    vParams.Add("@Comment", userStorySpentTimeSearchCriteriaInputModel.Comment);
                    vParams.Add("@PageSize", userStorySpentTimeSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNo", userStorySpentTimeSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStorySpentTimeApiReturnModel>(StoredProcedureConstants.SpSearchUserStorySpentTimes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStoryLogTime", "UserStorySpentTimeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStoryLogTime);
                return new List<UserStorySpentTimeApiReturnModel>();
            }
        }

        public List<UserStorySpentTimeApiReturnModel> SearchAuditQuestionLogTime(UserStorySpentTimeSearchCriteriaInputModel userStorySpentTimeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStorySpentTimeId", userStorySpentTimeSearchCriteriaInputModel.UserStorySpentTimeId);
                    vParams.Add("@UserStoryId", userStorySpentTimeSearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@UserId", userStorySpentTimeSearchCriteriaInputModel.UserId);
                    vParams.Add("@SpentTime", userStorySpentTimeSearchCriteriaInputModel.SpentTime);
                    vParams.Add("@Comment", userStorySpentTimeSearchCriteriaInputModel.Comment);
                    vParams.Add("@PageSize", userStorySpentTimeSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNo", userStorySpentTimeSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStorySpentTimeApiReturnModel>(StoredProcedureConstants.SpSearchAuditQuestionSpentTime, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditQuestionLogTime", "UserStorySpentTimeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStoryLogTime);
                return new List<UserStorySpentTimeApiReturnModel>();
            }
        }

        public List<UserStorySpentTimeReportSpOutputModel> SearchSpentTimeReport(SpentTimeReportSearchInputModel spentTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", spentTimeReportSearchInputModel.ProjectId);
                    vParams.Add("@DateDescription", spentTimeReportSearchInputModel.DateDescription);
                    vParams.Add("@DateFrom", spentTimeReportSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", spentTimeReportSearchInputModel.DateTo);
                    vParams.Add("@Days ", spentTimeReportSearchInputModel.Days);
                    vParams.Add("@UserDescription", spentTimeReportSearchInputModel.UserDescription);
                    vParams.Add("@UserStoryTypeDescription", spentTimeReportSearchInputModel.UserStoryTypeDescription);
                    vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                    vParams.Add("@HoursDescription", spentTimeReportSearchInputModel.HoursDescription);
                    vParams.Add("@HoursFrom", spentTimeReportSearchInputModel.HoursFrom);
                    vParams.Add("@HoursTo", spentTimeReportSearchInputModel.HoursTo);
                    vParams.Add("@PageSize", spentTimeReportSearchInputModel.PageSize);
                    vParams.Add("@PageNumber", spentTimeReportSearchInputModel.PageNumber);
                    vParams.Add("@SortBy", spentTimeReportSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", spentTimeReportSearchInputModel.SortDirection);
                    vParams.Add("@SearchText", spentTimeReportSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStorySpentTimeReportSpOutputModel>(StoredProcedureConstants.SpSearchSpentTimeReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSpentTimeReport", "UserStorySpentTimeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchSpentTimeReport);
                return new List<UserStorySpentTimeReportSpOutputModel>();
            }
        }
    }
}
