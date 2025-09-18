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
    public partial class UserStoryPriorityRepository
    {
        public List<UserStoryPriorityApiReturnModel> SearchUserStoryPriorities(UserStoryPriorityInputModel userStoryPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryPriorityId", userStoryPriorityInputModel.UserStoryPriorityId);
                    vParams.Add("@PriorityName", userStoryPriorityInputModel.PriorityName);
					vParams.Add("@IsArchived", userStoryPriorityInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryPriorityApiReturnModel>(StoredProcedureConstants.SpGetUserStoryPriorities, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStoryPriorities", "UserStoryPriorityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStoryPriorities);
                return new List<UserStoryPriorityApiReturnModel>();
            }
        }
    }
}
