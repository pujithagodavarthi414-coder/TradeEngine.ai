using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using BTrak.Common;
using Btrak.Models.Chat;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ChannelRepository
    {
        public List<MessageSpReturnModel> SelectChannelMessages(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@@IsForSingleMessageDetails", messageSearchInputModel.IsForSingleMessageDetails);
                vParams.Add("@MsgCount", messageSearchInputModel.MessageCount);
                vParams.Add("@LastMsgId", messageSearchInputModel.MessageId);
                vParams.Add("@SenderId", loggedInContext.LoggedInUserId);
                vParams.Add("@ReceiverId", null);
                vParams.Add("@ParentMessageId", messageSearchInputModel.ParentMessageId);
                vParams.Add("@ChannelId", messageSearchInputModel.ChannelId);
                vParams.Add("@DateTo", messageSearchInputModel.DateTo);
                vParams.Add("@DateFrom", messageSearchInputModel.DateFrom);
                vParams.Add("@IsArchived", messageSearchInputModel.IsArchived);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                return vConn.Query<MessageSpReturnModel>(StoredProcedureConstants.SpSearchMessages, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<MessageSpReturnModel> GetPinnedOrStaredMessages(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@SenderId", messageSearchInputModel.UserId);
                vParams.Add("@ReceiverId", loggedInContext.LoggedInUserId);
                vParams.Add("@ChannelId", messageSearchInputModel.ChannelId);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                return vConn.Query<MessageSpReturnModel>(StoredProcedureConstants.SPGetPinnedOrStaredMessages, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<ChannelMemberApiReturnModel> ChannelUsers(ChannelMemberSearchInputModel channelMemberSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@IsActive", channelMemberSearchInputModel.IsActive);
                    vParams.Add("@ChannelId", channelMemberSearchInputModel.ChannelId);
                    vParams.Add("@ProjectId", channelMemberSearchInputModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ChannelMemberApiReturnModel>(StoredProcedureConstants.SpGetChannelUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ChannelUsers", "ChannelRepository ", sqlException.Message), sqlException);

                string generalException = ValidationMessages.ExceptionActiveChannelMembers;
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, generalException);
                return null;
            }
        }

        public List<LatestPunchCardStatusOfAnUserApiReturnModel> GetLatestPunchCardStatusOfAnUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LatestPunchCardStatusOfAnUserApiReturnModel>(StoredProcedureConstants.SpGetLatestPunchCardStatusOfAnUser, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLatestPunchCardStatusOfAnUser", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsers);
                return new List<LatestPunchCardStatusOfAnUserApiReturnModel>();
            }
        }

        public List<RecentConversationsSpReturnModel> GetRecentConversations(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RecentConversationsSpReturnModel>(StoredProcedureConstants.SpGetRecentConversations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRecentConversations", "Channel Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRecentConversations);
                return new List<RecentConversationsSpReturnModel>();
            }
        }

        public List<SearchSharedorUnsharedchannelsOutputModel> GetSharedorUnsharedchannels(SearchSharedorUnsharedchannelsInputModel searchSharedorUnsharedchannelsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", searchSharedorUnsharedchannelsInputModel.UserId);
                    vParams.Add("@IsShared", searchSharedorUnsharedchannelsInputModel.IsShared);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SearchSharedorUnsharedchannelsOutputModel>(StoredProcedureConstants.SpGetSharedorUnsharedchannels, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSharedorUnsharedchannels", "Channel Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSharedorUnsharedchannels);
                return new List<SearchSharedorUnsharedchannelsOutputModel>();
            }
        }

        public List<ChannelMemberApiReturnModel> GetUsersForChannel(ChannelMemberSearchInputModel channelMemberSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ChannelId", channelMemberSearchInputModel.ChannelId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ChannelMemberApiReturnModel>(StoredProcedureConstants.SpGetUsersForChannel, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersForChannel", "ChannelRepository ", sqlException.Message), sqlException);

                string generalException = ValidationMessages.ExceptionInActiveChannelMembers;
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, generalException);
                return null;
            }
        }

        public Guid? UpsertChannel(ChannelUpsertInputModel aChannel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ChannelId", aChannel.ChannelId);
                    vParams.Add("@ChannelName", aChannel.ChannelName);
                    vParams.Add("@IsDeleted", aChannel.IsDeleted);
                    vParams.Add("@ChannelImage", aChannel.ChannelImage);
                    vParams.Add("@TimeStamp", aChannel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectId", aChannel.ProjectId);
                    vParams.Add("@CurrentOwnerShipId", aChannel.CurrentOwnerShipId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertChannel, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertChannel", "ChannelRepository ", sqlException.Message), sqlException);

                string generalException = ValidationMessages.ExceptionCreateNewChannel;
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, generalException);
                return null;
            }
        }

        public List<ChannelApiReturnModel> UserChannels(ChannelSearchInputModel channelSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", channelSearchInputModel.IsDeleted);
                    vParams.Add("@ProjectId", channelSearchInputModel.ProjectId);
                    vParams.Add("@UserId", channelSearchInputModel.UserId);
                    vParams.Add("@MemberUserId", channelSearchInputModel.MemberUserId);
                    vParams.Add("@ChannelId", channelSearchInputModel.ChannelId);
                    return vConn.Query<ChannelApiReturnModel>(StoredProcedureConstants.SpGetChannels, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UserChannels", "ChannelRepository ", sqlException.Message), sqlException);

                string generalException = ValidationMessages.ExceptionUserChannels;
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, generalException);
                return null;
            }
        }

        public bool ArchiveChannel(Guid channelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var blResult = false;

                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@Id", channelId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    int iResult = vConn.Execute(StoredProcedureConstants.SpChannelArchive, vParams, commandType: CommandType.StoredProcedure);
                    if (iResult == -1) blResult = true;
                }

                return blResult;
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveChannel", "ChannelRepository ", sqlException.Message), sqlException);

                string generalException = ValidationMessages.ExceptionArchiveChannel;
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, generalException);
                return false;
            }
        }

        public List<RecentIndividualConversationSpReturnModel> GetRecentIndividualMessages(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RecentIndividualConversationSpReturnModel>(StoredProcedureConstants.SpGetRecentIndividualMessages, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRecentIndividualMessages", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRecentIndividualMessages);
                return new List<RecentIndividualConversationSpReturnModel>();
            }
        }

        public List<RecentChannelConversationApiReturnModel> GetRecentChannelMessages(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RecentChannelConversationApiReturnModel>(StoredProcedureConstants.SpGetRecentChannelMessages, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRecentChannelMessages", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRecentChannelMessages);
                return new List<RecentChannelConversationApiReturnModel>();
            }
        }

        public List<MessageShareSpReturnModel> ShareMessageToContacts(MessageShareModel messageShareModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@MessageId", messageShareModel.ShareMessageId);
                    vParams.Add("@MessagesXml", messageShareModel.MessagesXml);
                    return vConn.Query<MessageShareSpReturnModel>("USP_ShareMessage", vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ShareMessageToContacts", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return new List<MessageShareSpReturnModel>();
            }
        }

        public bool UpsertMuteOrStarContact(MuteOrStarContactModel muteOrStarContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ChannelId", muteOrStarContactModel.ChannelId);
                    vParams.Add("@UserId", muteOrStarContactModel.UserId);
                    vParams.Add("@IsMuted", muteOrStarContactModel.IsMuted);
                    vParams.Add("@IsStarred", muteOrStarContactModel.IsStarred);
                    vParams.Add("@IsLeave", muteOrStarContactModel.IsLeave);
                    return vConn.Execute("USP_UpsertMuteOrStarContact", vParams, commandType: CommandType.StoredProcedure) == -1;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMuteOrStarContact", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return false;
            }
        }

        public bool UpsertMessageReadReceipt(MessageReadReceiptInputModel messageReadReceiptInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SenderUserId", messageReadReceiptInputModel.SenderuserId);
                    vParams.Add("@MessageId", messageReadReceiptInputModel.MessageId);
                    vParams.Add("@MessageDateTime", messageReadReceiptInputModel.MessageDateTime);
                    vParams.Add("@IsChannel", messageReadReceiptInputModel.IsChannel);
                    return vConn.Execute(StoredProcedureConstants.SpUpsertMessageReadReceipt, vParams, commandType: CommandType.StoredProcedure) == -1;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMessageReadReceipt", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return false;
            }
        }

        public List<StarredMessagesApiReturnModel> GetAllStarredMessages(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ReceiverId", messageSearchInputModel.UserId);
                    vParams.Add("@ChannelId", messageSearchInputModel.ChannelId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<StarredMessagesApiReturnModel>(StoredProcedureConstants.GetAllStarredMessages, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllStarredMessages", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return new List<StarredMessagesApiReturnModel>();
            }
        }

        public bool UpsertMessengerLog(MessengerAuditInputModel muteOrStarContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", muteOrStarContactModel.UserId);
                    vParams.Add("@PlatformId", muteOrStarContactModel.PlatformId);
                    vParams.Add("@StatusId", muteOrStarContactModel.StatusId);
                    vParams.Add("@IpAddress", muteOrStarContactModel.IpAddress);
                    return vConn.Execute(StoredProcedureConstants.UpsertMessengerAudit, vParams, commandType: CommandType.StoredProcedure) == -1;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMessengerLog", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return false;
            }
        }

        public List<UserStatusTimesOutputModel> GetUserLastStatusTime(UserStatusTimesInputModel userStatusTimesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userStatusTimesInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStatusTimesOutputModel>(StoredProcedureConstants.SpGetUserStatusFromTime, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserLastStatusTime", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return new List<UserStatusTimesOutputModel>();
            }
        }

        public List<UserStatusHistoryOutputModel> GetUserStatusHistory(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStatusHistoryOutputModel>(StoredProcedureConstants.SpGetUserStatusHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStatusHistory", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return new List<UserStatusHistoryOutputModel>();
            }
        }

        public UnreadMessagesCountOutputModel GetUnreadMessagesCount(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UnreadMessagesCountOutputModel>(StoredProcedureConstants.SpGetUnreadMessagesCount, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnreadMessagesCount", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return new UnreadMessagesCountOutputModel();
            }
        }

        public bool UpdateUnreadMessages(UnReadMessagesInputModel unReadMessagesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@MessagetypeEnum", unReadMessagesInputModel.Type);
                    vParams.Add("@MessageIdsString", string.Join(",", unReadMessagesInputModel.ContactsOrChannelIds));
                    return vConn.Execute(StoredProcedureConstants.SpUpdateUnreadMessages, vParams, commandType: CommandType.StoredProcedure) == -1;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUnreadMessages", "ChannelRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return false;
            }
        }
    }
}
