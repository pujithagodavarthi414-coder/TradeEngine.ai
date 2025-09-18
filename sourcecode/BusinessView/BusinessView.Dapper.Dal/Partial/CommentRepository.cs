using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Comments;
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
    public partial class CommentRepository
    {
        public Guid? UpsertComment(CommentUserInputModel commentModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CommentId", commentModel.CommentId);
                    vParams.Add("@CommentedByUserId", loggedInContext.LoggedInUserId); //TODO: Need to remove this. Need to handle this in SP
                    vParams.Add("@ReceiverId", commentModel.ReceiverId);
                    vParams.Add("@Comment", commentModel.Comment);
                    vParams.Add("@ParentCommentId", commentModel.ParentCommentId);
                    vParams.Add("@AdminFlag", false);
                    vParams.Add("@TimeZone", commentModel.TimeZone);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertComment, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertComment", "CommentRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCommentUpsert);
                return null;
            }
        }

        public List<CommentSpReturnModel> SearchComments(CommentsSearchCriteriaInputModel commentsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CommentId", commentsSearchCriteriaInputModel.CommentId);
                    vParams.Add("@CommentedByUserId", commentsSearchCriteriaInputModel.CommentedByUserId);
                    vParams.Add("@Comment", commentsSearchCriteriaInputModel.SearchText);
                    vParams.Add("@ReceiverId", commentsSearchCriteriaInputModel.ReceiverId);
                    vParams.Add("@AdminFlag", commentsSearchCriteriaInputModel.AdminFlag);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageSize", commentsSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", commentsSearchCriteriaInputModel.PageNumber);
                    return vConn.Query<CommentSpReturnModel>(StoredProcedureConstants.SpSearchComments, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchComments", "CommentRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchComments);
                return new List<CommentSpReturnModel>();
            }
        }
    }
}
