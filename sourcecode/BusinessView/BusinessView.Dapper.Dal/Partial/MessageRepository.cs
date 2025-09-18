using Btrak.Dapper.Dal.SpModels;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Models;
using Btrak.Models.Chat;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class MessageRepository : BaseRepository
    {
        public UpsertMessageOutputModel MessagesInsert(MessageUpsertInputModel aMessage, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@MessageId", aMessage.Id);
                vParams.Add("@ChannelId", aMessage.ChannelId);
                vParams.Add("@SenderUserId", aMessage.SenderUserId);
                vParams.Add("@ReceiverUserId", aMessage.ReceiverUserId);
                vParams.Add("@ParentMessageId", aMessage.ParentMessageId);
                vParams.Add("@TextMessage", aMessage.TextMessage);
                vParams.Add("@IsDeleted", aMessage.IsDeleted);
                vParams.Add("@MessageType", aMessage.MessageType);
                vParams.Add("@FilePath", aMessage.FilePath);
                vParams.Add("@TimeStamp", aMessage.TimeStamp, DbType.Binary);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                vParams.Add("@IsActivityMessage", aMessage.IsActivityMessage);
                vParams.Add("@IsPinned", aMessage.IsPinned);
                vParams.Add("@IsStarred", aMessage.IsStarred);
                vParams.Add("@PinnedByUserId", aMessage.PinnedByUserId);
                vParams.Add("@ReactedByUserId", aMessage.ReactedByUserId);
                vParams.Add("@TaggedMembersIdsXml", aMessage.TaggedMembersIdsXml);
                vParams.Add("@IsFromBackend", aMessage.IsFromBackend);
                vParams.Add("@ReportMessage", aMessage.ReportMessage);
                vParams.Add("@LastReplayDateTime", aMessage.LastThreadMessageTime);
                return vConn.Query<UpsertMessageOutputModel>(StoredProcedureConstants.SpUpsertMessage, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();             
            }
        }

        public List<MessageSpReturnModel> SelectMessagesBetweenTwoUsers(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@@IsForSingleMessageDetails", messageSearchInputModel.IsForSingleMessageDetails);
                vParams.Add("@MsgCount", messageSearchInputModel.MessageCount);
                vParams.Add("@LastMsgId", messageSearchInputModel.MessageId);
                vParams.Add("@SenderId", messageSearchInputModel.UserId);
                vParams.Add("@ReceiverId", loggedInContext.LoggedInUserId);
                vParams.Add("@ParentMessageId", messageSearchInputModel.ParentMessageId);
                vParams.Add("@ChannelId", null);
                vParams.Add("@IsArchived", messageSearchInputModel.IsArchived);
                vParams.Add("@DateTo", messageSearchInputModel.DateTo);
                vParams.Add("@DateFrom", messageSearchInputModel.DateFrom);
                //vParams.Add("@MessageId", messageSearchInputModel.MessageId);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                return vConn.Query<MessageSpReturnModel>(StoredProcedureConstants.SpSearchMessages, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<MessageSpReturnModel> GetLatestMessages(LatestMessageSearchInputModel latestMessageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ConversationId", latestMessageSearchInputModel.ConversationId);
                vParams.Add("@MessageId", latestMessageSearchInputModel.MessageId);
                vParams.Add("@IsChannel", latestMessageSearchInputModel.IsChannel);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                return vConn.Query<MessageSpReturnModel>(StoredProcedureConstants.GetLatestMessages, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }


        public List<MessagesListSpEntity> GetMessagesCount(Guid receiverId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@SenderId", null);
                vParams.Add("@ReceiverId", receiverId);
                vParams.Add("@ChannelId", null);
                return vConn.Query<MessagesListSpEntity>(StoredProcedureConstants.SpMessagesCount, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public void AddOrUpdateUserFcmTokenDetails(string userId, string deviceUniqueId, string fcmToken, bool isDelete, bool isFromBTrakMobile, LoggedInContext loggedInContext)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserFcmDetailId", null);
                vParams.Add("@UserId", userId);
                vParams.Add("@FcmToken", fcmToken);
                vParams.Add("@DeviceUniqueId", deviceUniqueId);
                vParams.Add("@IsDelete", isDelete);
                vParams.Add("@IsFromBTrakMobile", isFromBTrakMobile);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                vConn.Execute(StoredProcedureConstants.SpUpsertUserFcmDetails, vParams, commandType: CommandType.StoredProcedure);
            }
        }

        public List<FcmDetailsSpEntity> GetFcmDetails(string userId, bool isFromBtrakMobile)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@IsFromBtrakMobile", isFromBtrakMobile);
                return vConn.Query<FcmDetailsSpEntity>(StoredProcedureConstants.SpGetUserFcmDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<SharedFilesApiReturnModel> GetSharedFiles(SharedFilesSearchInputModel sharedFilesSearchInputModel, LoggedInContext loggedInContext)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", sharedFilesSearchInputModel.UserId);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                vParams.Add("@ChannelId", sharedFilesSearchInputModel.ChannelId);
                return vConn.Query<SharedFilesApiReturnModel>("USP_GetSharedFiles", vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
