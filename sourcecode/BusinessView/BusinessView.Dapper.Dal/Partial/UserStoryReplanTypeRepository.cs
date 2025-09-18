using System;
using Btrak.Models.Status;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.UserStory;
using Btrak.Models.MasterData;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserStoryReplanTypeRepository
    {
        public List<UserStoryReplanTypeOutputModel> GetUserStoryReplanTypes(UserStoryReplanTypeSearchCriteriaInputModel userStoryReplanTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReplanTypeName", userStoryReplanTypeSearchCriteriaInputModel.ReplanTypeName);
                    vParams.Add("@IsArchived", userStoryReplanTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@UserStoryReplanTypeId", userStoryReplanTypeSearchCriteriaInputModel.ReplanTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryReplanTypeOutputModel>(StoredProcedureConstants.SpGetUserStoryReplanTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryReplanTypes", "UserStoryReplanTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoryReplanTypes);
                return new List<UserStoryReplanTypeOutputModel>();
            }
        }

        public List<UserStoryTypeSearchInputModel> GetUserStoryTypes(UserStoryTypeSearchInputModel userStoryReplanTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryTypeName", userStoryReplanTypeSearchCriteriaInputModel.UserStoryTypeName);
                    vParams.Add("@IsArchived", userStoryReplanTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@UserStoryTypeId", userStoryReplanTypeSearchCriteriaInputModel.UserStoryTypeId);
                    vParams.Add("@GenericStatusType", userStoryReplanTypeSearchCriteriaInputModel.GenericStatusType);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryTypeSearchInputModel>(StoredProcedureConstants.SpGetUserStoryTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryTypes", "UserStoryReplanTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoryReplanTypes);
                return new List<UserStoryTypeSearchInputModel>();
            }
        }

        public Guid? UpsertUserStoryReplanType(UpsertUserStoryReplanTypeInputModel upsertUserStoryReplanTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryReplanTypeId", upsertUserStoryReplanTypeInputModel.UserStoryReplanTypeId);
                    vParams.Add("@ReplanTypeName", upsertUserStoryReplanTypeInputModel.ReplanTypeName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("IsArchived", upsertUserStoryReplanTypeInputModel.IsArchived);
                    vParams.Add("TimeStamp", upsertUserStoryReplanTypeInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryReplanType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryReplanType", "UserStoryReplanTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryReplanType);
                return null;
            }
        }

        public Guid? UpsertUserStoryType(UpsertUserStoryTypeInputModel userStoryTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryTypeId", userStoryTypeSearchCriteriaInputModel.UserStoryTypeId);
                    vParams.Add("@UserStoryTypeName", userStoryTypeSearchCriteriaInputModel.UserStoryTypeName);
                    vParams.Add("@UserStoryTypeShortName", userStoryTypeSearchCriteriaInputModel.ShortName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("IsArchived", userStoryTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsQaRequired", userStoryTypeSearchCriteriaInputModel.IsQaRequired);
                    vParams.Add("@IsBug", userStoryTypeSearchCriteriaInputModel.IsBug);
                    vParams.Add("@IsAction", userStoryTypeSearchCriteriaInputModel.IsAction);
                    vParams.Add("@IsLogTimeRequired", userStoryTypeSearchCriteriaInputModel.IsLogTimeRequired);
                    vParams.Add("@UserStoryTypeColor", userStoryTypeSearchCriteriaInputModel.UserStoryTypeColor);
                    vParams.Add("TimeStamp", userStoryTypeSearchCriteriaInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryType", "UserStoryReplanTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryReplanType);
                return null;
            }
        }

        public Guid? DeleteUserStoryType(UpsertUserStoryTypeInputModel userStoryTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryTypeId", userStoryTypeSearchCriteriaInputModel.UserStoryTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("IsArchived", userStoryTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("TimeStamp", userStoryTypeSearchCriteriaInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteUserStoryType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteUserStoryType", "UserStoryReplanTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteUserStoryType);
                return null;
            }
        }
    }
}
