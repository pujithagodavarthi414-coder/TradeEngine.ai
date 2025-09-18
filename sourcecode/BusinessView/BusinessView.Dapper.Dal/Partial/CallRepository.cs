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
using Btrak.Models.Crm.Call;

namespace Btrak.Dapper.Dal.Partial
{
    public class CallRepository : BaseRepository
    {
        public Guid? UpsertCallFeedback(CallFeedbackUserInputModel callFeedbackModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CallFeedbackId", callFeedbackModel.CallFeedbackId);
                    vParams.Add("@FeedbackByUserId", callFeedbackModel.FeedbackByUserId);
                    vParams.Add("@ReceiverId", callFeedbackModel.ReceiverId);
                    vParams.Add("@CallConnectedTo", callFeedbackModel.CallConnectedTo);
                    vParams.Add("@CallOutcomeCode", callFeedbackModel.CallOutcomeCode);
                    vParams.Add("@CallStartedOn", callFeedbackModel.CallStartedOn);
                    vParams.Add("@CallEndedOn", callFeedbackModel.CallEndedOn);
                    vParams.Add("@CallRecordingLink", callFeedbackModel.CallRecordingLink);
                    vParams.Add("@CallDescription", callFeedbackModel.CallDescription);
                    vParams.Add("@CallLogDate", callFeedbackModel.CallLoggedDate);
                    vParams.Add("@CallLogTime", callFeedbackModel.CallLoggedTime);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ActivityType", callFeedbackModel.ActivityType);
                    vParams.Add("@CallResource", callFeedbackModel.CallResource);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCallFeedback, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCallFeedback", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCommentUpsert);
                return null;
            }
        }

        public List<CallFeedbackSpReturnModel> SearchCallFeedback(CallFeedbackSearchCriteriaInputModel callFeedbackSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CallFeedbackId", callFeedbackSearchCriteriaInputModel.CallFeedbackId);
                    vParams.Add("@CallFeedbackUserId", callFeedbackSearchCriteriaInputModel.CallFeedbackUserId);
                    vParams.Add("@ReceiverId", callFeedbackSearchCriteriaInputModel.ReceiverId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageSize", callFeedbackSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", callFeedbackSearchCriteriaInputModel.PageNumber);
                    return vConn.Query<CallFeedbackSpReturnModel>(StoredProcedureConstants.SpSearchCallFeedback, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCallFeedback", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchComments);
                return new List<CallFeedbackSpReturnModel>();
            }
        }

        public List<CallOutcomeModel> GetCallOutcome(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CallOutcomeModel>(StoredProcedureConstants.SpGetCallOutcomes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCallFeedback", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetOutcomes);
                return new List<CallOutcomeModel>();
            }
        }

        public Guid? UpsertRoomVideo(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", roomDetails.Id);
                    vParams.Add("@UniqueName", roomDetails.Name);
                    vParams.Add("@RoomSid", roomDetails.RoomSid);
                    vParams.Add("@Status", roomDetails.Status.ToString());
                    vParams.Add("@ReferenceId", roomDetails.ReceiverId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRoomVideo, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRoomVideo", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetOutcomes);
                return null;
            }
        }

        public bool UpsertRoomVideoValidation(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UniqueName", roomDetails.Name);
                    vParams.Add("@ReferenceId", roomDetails.ReceiverId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpUpsertRoomVideoValidation, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRoomVideoValidation", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetOutcomes);
                return false;
            }
        }

        public RoomDetailsModel GetVideoRoomDetails(RoomDetailsModel roomDetails, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UniqueName", roomDetails.Name);
                    //vParams.Add("@ReceiverId", roomDetails.ReceiverId);
                    return vConn.Query<RoomDetailsModel>(StoredProcedureConstants.SpSearchRoomVideoDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetVideoRoomDetails", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetOutcomes);
                return null;
            }
        }

        public Guid? UpsertVideoCallLog(VideoCallLogInputModel videoCallLogInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@VideoCallLogId", videoCallLogInputModel.VideoCallLogId);
                    vParams.Add("@ReceiverId", videoCallLogInputModel.ReceiverId);
                    vParams.Add("@RoomName", videoCallLogInputModel.RoomName);
                    vParams.Add("@VideoRecordingLink", videoCallLogInputModel.VideoRecordingLink);
                    vParams.Add("@Extension", videoCallLogInputModel.Extension);
                    vParams.Add("@Type", videoCallLogInputModel.Type);
                    vParams.Add("@FileName", videoCallLogInputModel.FileName);
                    vParams.Add("@CompositionSid", videoCallLogInputModel.CompositionSid);
                    vParams.Add("@RoomSid", videoCallLogInputModel.RoomSid);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertVideoCallLog, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertVideoCallLog", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCommentUpsert);
                return null;
            }
        }

        public List<VideoCallLogOutputModel> SearchVideoCallLog(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReceiverId", roomDetails.ReceiverId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<VideoCallLogOutputModel>(StoredProcedureConstants.SpSearchVideoCallLog, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchVideoCallLog", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCommentUpsert);
                return null;
            }
        }

        public VideoCallLogOutputModel GetVideoCallLogByComposition(string compositonId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompositionSid", compositonId);
                    return vConn.Query<VideoCallLogOutputModel>(StoredProcedureConstants.SpSearchVideoCallLog, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetVideoCallLogByComposition", "CallRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCommentUpsert);
                return null;
            }
        }
    }
}
