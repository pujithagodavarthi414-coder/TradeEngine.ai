using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.MasterData.FeedbackTypeModel;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class FeedbackTypeMasterDataRepository : BaseRepository
    {
        public Guid? UpsertFeedbackFormType(UpsertFeedbackTypeModel upsertFeedbackTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FeedBackTypeId", upsertFeedbackTypeModel.FeedbackTypeId);
                    vParams.Add("@FeedBackTypeName", upsertFeedbackTypeModel.FeedbackTypeName);
                    vParams.Add("@TimeStamp", upsertFeedbackTypeModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", upsertFeedbackTypeModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFeedbackType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFeedbackFormType", "FeedbackTypeMasterDataRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionFeedbacktype);
                return null;
            }
        }

        public List<GetFeedbackTypeSearchCriteriaInputModel> GetFeedbackType(GetFeedbackTypeSearchCriteriaInputModel getFeedbackTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FeedBackTypeId", getFeedbackTypeSearchCriteriaInputModel.FeedbackTypeId);
                    vParams.Add("@FeedBackTypeName", getFeedbackTypeSearchCriteriaInputModel.FeedbackTypeName);
                    vParams.Add("@SearchText", getFeedbackTypeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getFeedbackTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetFeedbackTypeSearchCriteriaInputModel>(StoredProcedureConstants.SpGetFeedbackType, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFeedbackType", "FeedbackTypeMasterDataRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFeedbackType);
                return new List<GetFeedbackTypeSearchCriteriaInputModel>();
            }
        }
    }
}