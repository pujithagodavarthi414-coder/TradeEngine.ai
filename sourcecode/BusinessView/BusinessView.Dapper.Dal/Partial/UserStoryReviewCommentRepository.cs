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
    public partial class UserStoryReviewCommentRepository
    {
        public Guid? UpsertUserStoryReviewComment(UserStoryReviewCommentUpsertInputModel userStoryReviewCommentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryReviewCommentId", userStoryReviewCommentUpsertInputModel.UserStoryReviewCommentId);
                    vParams.Add("@UserStoryId", userStoryReviewCommentUpsertInputModel.UserStoryId);
                    vParams.Add("@Comment", userStoryReviewCommentUpsertInputModel.Comment);
                    vParams.Add("@UserStoryReviewStatusId", userStoryReviewCommentUpsertInputModel.UserStoryReviewStatusId);
                    vParams.Add("@TimeStamp", userStoryReviewCommentUpsertInputModel.TimeStamp, DbType.Binary);
					vParams.Add("@IsArchived", userStoryReviewCommentUpsertInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryReviewComment, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryReviewComment", "UserStoryReviewCommentRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryReviewCommentUpsert);
                return null;
            }
        }
    }
}
