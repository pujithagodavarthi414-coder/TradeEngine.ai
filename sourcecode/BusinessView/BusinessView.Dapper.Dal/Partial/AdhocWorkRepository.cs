using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.AdhocWork;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Partial
{
    public class AdhocWorkRepository : BaseRepository
    {
        public List<GetAdhocWorkOutputModel> SearchAdhocWork(AdhocWorkSearchInputModel adhocWorkSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TeamMemberIdsXML", adhocWorkSearchInputModel.TeamMembersXml);
                    vParams.Add("@UserStoryId", adhocWorkSearchInputModel.UserStoryId);
                    vParams.Add("@IsIncludeCompletedUserStories", adhocWorkSearchInputModel.IsIncludeCompletedUserStories);
                    vParams.Add("@PageSize", adhocWorkSearchInputModel.PageSize);
                    vParams.Add("@PageNumber", adhocWorkSearchInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsParked", adhocWorkSearchInputModel.IsParked);
                    vParams.Add("@IsArchived", adhocWorkSearchInputModel.IsArchived);
                    vParams.Add("@SearchUserstoryTag", adhocWorkSearchInputModel.SearchUserstoryTag);
                    return vConn.Query<GetAdhocWorkOutputModel>(StoredProcedureConstants.SpSearchAdhocWork, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAdhocWork", " AdhocWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchAdhocWork);
                return new List<GetAdhocWorkOutputModel>();
            }
        }

        public Guid? UpsertAdhocWork(AdhocWorkInputModel adhocWorkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", adhocWorkInputModel.UserStoryId);
                    vParams.Add("@UserStoryName", adhocWorkInputModel.UserStoryName);
                    vParams.Add("@EstimatedTime", adhocWorkInputModel.EstimatedTime);
                    vParams.Add("@DeadLineDate", adhocWorkInputModel.DeadLineDate);
                    vParams.Add("@OwnerUserId", adhocWorkInputModel.OwnerUserId);
                    vParams.Add("@DependencyUserId", adhocWorkInputModel.DependencyUserId);
                    vParams.Add("@Order", adhocWorkInputModel.Order);
                    vParams.Add("@UserStoryStatusId", adhocWorkInputModel.UserStoryStatusId);
                    vParams.Add("@IsArchived", adhocWorkInputModel.IsArchived);
                    vParams.Add("@ArchivedDateTime", adhocWorkInputModel.ArchivedDateTime);
                    vParams.Add("@UserStoryTypeId", adhocWorkInputModel.UserStoryTypeId);
                    vParams.Add("@ParkedDateTime", adhocWorkInputModel.ParkedDateTime);
                    vParams.Add("@ProjectFeatureId", adhocWorkInputModel.ProjectFeatureId);
                    vParams.Add("@UserStoryPriorityId", adhocWorkInputModel.UserStoryPriorityId);
                    vParams.Add("@ReviewerUserId", adhocWorkInputModel.ReviewerUserId);
                    vParams.Add("@CompanyName", adhocWorkInputModel.CompanyName);
                    vParams.Add("@ParentUserStoryId", adhocWorkInputModel.ParentUserStoryId);
                    vParams.Add("@Description", adhocWorkInputModel.Description);
                    vParams.Add("@GenericFormSubmittedId", adhocWorkInputModel.GenericFormSubmittedId);
                    vParams.Add("@WorkspaceDashboardId", adhocWorkInputModel.WorkspaceDashboardId);
                    vParams.Add("@CustomApplicationId", adhocWorkInputModel.CustomApplicationId);
                    vParams.Add("@IsInductionGoal", adhocWorkInputModel.IsInductionGoal);
                    vParams.Add("@IsExitGoal", adhocWorkInputModel.IsExitGoal);
                    vParams.Add("@FormId", adhocWorkInputModel.FormId);
                    vParams.Add("@ReferenceId", adhocWorkInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", adhocWorkInputModel.ReferenceTypeId);
                    vParams.Add("@TimeStamp", adhocWorkInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    vParams.Add("@IsWorkflowStatus", adhocWorkInputModel.IsWorkflowStatus);
                    vParams.Add("@FileIds", adhocWorkInputModel.FileIds);
                    vParams.Add("@TimeZone", adhocWorkInputModel.TimeZone);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAdhocWork, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAdhocWork", " AdhocWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAdhocWork);
                return null;
            }
        }
    }
}
