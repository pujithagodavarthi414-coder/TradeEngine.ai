using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.UserStory;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Partial
{
   public partial  class UserStoryLinkRepository : BaseRepository
    {
        public List<UserStoryLinkTypeOutputModel> SearchUserStoryLinkTypes(UserStoryLinkTypesSearchCriteriaInputModel userStoryLinkTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryLinkTypeId", userStoryLinkTypeSearchCriteriaInputModel.LinkUserStoryTypeId);
                    vParams.Add("@UserStoryLinkTypeName", userStoryLinkTypeSearchCriteriaInputModel.LinkUserStoryTypeName);
                    vParams.Add("@IsArchived", userStoryLinkTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryLinkTypeOutputModel>(StoredProcedureConstants.SpGetUserStoryLinkTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStoryLinkTypes", "UserStoryLinkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStoryLinksTypes);
                return new List<UserStoryLinkTypeOutputModel>();
            }
        }

        public List<UserStoryLinksOutputModel> SearchUserStoryLinks(UserStoryLinksSearchCriteriaModel userStoryLinkTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryLinkTypeSearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@LinkUserStoryId", userStoryLinkTypeSearchCriteriaInputModel.UserStoryLinkId);
                    vParams.Add("@IsSprintUserStories", userStoryLinkTypeSearchCriteriaInputModel.IsSprintUserStories);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryLinksOutputModel>(StoredProcedureConstants.SpGetUserStoryLinks, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStoryLinks", "UserStoryLinkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStoryLinks);
                return new List<UserStoryLinksOutputModel>();
            }
        }

        public Guid ? UpsertUserStoryLink(UserStoryLinkUpsertModel userStoryLinkUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryLinkUpsertModel.UserStoryId);
                    vParams.Add("@TimeZone", userStoryLinkUpsertModel.TimeZone);
                    vParams.Add("@LinkUserStoryId", userStoryLinkUpsertModel.LinkUserStoryId);
                    vParams.Add("@UserStoryLinkId", userStoryLinkUpsertModel.UserStoryLinkId);
                    vParams.Add("@LinkUserStoryTypeId", userStoryLinkUpsertModel.LinkUserStoryTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryLink, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryLink", "UserStoryLinkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertUserStoryLink);
                return Guid.Empty;
            }
        }

        public Guid? ArchiveUserStoryLink(ArchivedUserStoryLinkInputModel archivedUserStoryLinkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", archivedUserStoryLinkInputModel.UserStoryId);
                    vParams.Add("@UserStoryLinkId", archivedUserStoryLinkInputModel.UserStoryLinkId);
                    vParams.Add("@TimeStamp", archivedUserStoryLinkInputModel.TimeStamp);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", archivedUserStoryLinkInputModel.IsArchived);
                    vParams.Add("@TimeZone", archivedUserStoryLinkInputModel.TimeZone);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpArchiveUserStoryLink, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveUserStoryLink", "UserStoryLinkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionArchiveUserStoryLink);
                return Guid.Empty;
            }
        }

        public int? GetLinksCountByUserStoryId(Guid? userStoryId, bool? isSprintUserStories, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsSprintUserStories", isSprintUserStories);
                    return vConn.Query<int?>(StoredProcedureConstants.SpLinksCountByUserStoryId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLinksCountByUserStoryId", "UserStoryLinkRepository", sqlException.Message), sqlException);
                 SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLinksCountByUserStoryId);
                return null;
            }
        }

    }
}
