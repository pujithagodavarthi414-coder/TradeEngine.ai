using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Feedback;
using Btrak.Models.UserStory;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Partial
{
    public class FeedbackRepository : BaseRepository
    {
        public Guid? SubmitFeedBackForm(FeedbackSubmitModel upsertFeedbackModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FeedBackId", upsertFeedbackModel.FeedbackId);
                    vParams.Add("@Description", upsertFeedbackModel.Description);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpSubmitFeedBackForm, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SubmitFeedBackForm", "FeedbackRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSubmitFeedbackForm);
                return null;
            }
        }

        public List<FeedbackApiReturnModel> SearchFeedbacks(FeedbackSearchCriteriaInputModel feedbackSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FeedBackId", feedbackSearchCriteriaInputModel.FeedbackId);
                    vParams.Add("@Description", feedbackSearchCriteriaInputModel.Description);
                    vParams.Add("@PageNumber", feedbackSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", feedbackSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SearchText", feedbackSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FeedbackApiReturnModel>(StoredProcedureConstants.SpSearchFeedbacks, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFeedbacks", "FeedbackRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionNotGettingFeedbacks);
                return null;
            }
        }

        public Guid? SubmitBugFeedback(UserStoryUpsertInputModel  bugInsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", bugInsertModel.UserStoryId);
                    vParams.Add("@UserStoryName", bugInsertModel.UserStoryName);
                    vParams.Add("@Description", bugInsertModel.Description);
                    vParams.Add("@UserStoryTypeId", bugInsertModel.UserStoryTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpSubmitBugFeedback, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SubmitBugFeedback", "FeedbackRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSubmitBugFeedback);
                return null;
            }
        }

        public Guid? UpsertMissingFeature(UserStoryUpsertInputModel featureUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", featureUpsertModel.UserStoryId);
                    vParams.Add("@UserStoryName", featureUpsertModel.UserStoryName);
                    vParams.Add("@Description", featureUpsertModel.Description);
                    vParams.Add("@UserStoryTypeId", featureUpsertModel.UserStoryTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertMissingFeature, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMissingFeature", "FeedbackRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertMissingFeature);
                return null;
            }
        }

    }
}
