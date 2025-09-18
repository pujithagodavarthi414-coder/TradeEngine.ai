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

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserStorySubTypeRepository
    {
        public Guid? UpsertUserStorySubType(UserStorySubTypeUpsertInputModel userStorySubTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStorySubTypeId", userStorySubTypeUpsertInputModel.UserStorySubTypeId);
                    vParams.Add("@UserStorySubTypeName", userStorySubTypeUpsertInputModel.UserStorySubTypeName);
					vParams.Add("@TimeStamp", userStorySubTypeUpsertInputModel.TimeStamp, DbType.Binary);
					vParams.Add("@IsArchived", userStorySubTypeUpsertInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStorySubType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStorySubType", "UserStorySubTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStorySubTypeUpsert);
                return null;
            }
        }

        public List<UserStorySubTypeApiReturnModel> SearchUserStorySubTypes(UserStorySubTypeSearchCriteriaInputModel userStorySubTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStorySubTypeId", userStorySubTypeSearchCriteriaInputModel.UserStorySubTypeId);
                    vParams.Add("@UserStorySubTypeName", userStorySubTypeSearchCriteriaInputModel.UserStorySubTypeName);
                    vParams.Add("@SearchText", userStorySubTypeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", userStorySubTypeSearchCriteriaInputModel.SortBy);
                    vParams.Add("@IsArchived", userStorySubTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@SortDirection", userStorySubTypeSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageSize", userStorySubTypeSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", userStorySubTypeSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStorySubTypeApiReturnModel>(StoredProcedureConstants.SpGetUserStorySubTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStorySubTypes", "UserStorySubTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStorySubTypes);
                return new List<UserStorySubTypeApiReturnModel>();
            }
        }
    }
}
