using Btrak.Models;
using Btrak.Models.Chat;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web;
using System.Threading.Tasks;

namespace Btrak.Services.Chat
{
    public interface IChatService
    {
        IList<MessageCountModel> GetMessagesCount(Guid userId);

        Guid? CreateNewChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<ChannelApiReturnModel> GetUserChannels(ChannelSearchInputModel channelSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool ArchiveChannel(Guid channelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? AddEmployeesToChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<ChannelMemberApiReturnModel> GetChannelMembers(ChannelMemberSearchInputModel channelMemberSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveChannelMembers(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        UpsertMessageOutputModel SendMessageToChannelOrUser(MessageUpsertInputModel individualMessageModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<MessageApiReturnModel> GetPersonalChat(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<MessageApiReturnModel> GetChannelChat(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        void AddOrUpdateUserFcmDetails(string userId, string userUniqueId, string fcmToken, bool isDelete, bool isFromBTrakMobile, LoggedInContext loggedInContext);

        List<RecentIndividualConversationSpReturnModel> GetRecentIndividualMessages(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RecentChannelConversationApiReturnModel> GetRecentChannelMessages(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UpsertMessageOutputModel InsertMessageInUserStoryChannel(Guid? channelId, LoggedInContext loggedInContext, MessageDto messageDto = null, bool? isMember = null, bool isFromUserStoryChannel = false);

        IList<MessageApiReturnModel> GetPinnedOrStaredMessages(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<MessageShareSpReturnModel> ShareMessageToContacts(MessageShareModel messageShareModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        bool UpsertMuteOrStarContact(MuteOrStarContactModel muteOrStarContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<StarredMessagesApiReturnModel> GetAllStarredMessages(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SharedFilesApiReturnModel> GetSharedFiles(SharedFilesSearchInputModel sharedFilesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void SendPublicMessageToChannel(WebHookInputModel webHookInputModel);

        bool UpsertMessengerLog(MessengerAuditInputModel muteOrStarContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<UserStatusTimesOutputModel> GetUserLastStatusTime(UserStatusTimesInputModel userStatusTimesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<UserStatusHistoryOutputModel> GetUserStatusHistory(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UnreadMessagesCountOutputModel GetUnreadMessagesCount(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        bool UpdateMessageReadReceipt(MessageReadReceiptInputModel messageReadReceiptInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void SendFeedback(HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string senderName);

        bool UpdateUnreadMessages(UnReadMessagesInputModel unReadMessagesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<MessageApiReturnModel> GetLatestMessages(LatestMessageSearchInputModel latestMessageSearchInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        
        PubnubKeysApiReturnModel GetPubnubKeysFromSettings(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        bool UpdateIsReadOnlyForChannelMembers(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LatestPunchCardStatusOfAnUserApiReturnModel> GetLatestPunchCardStatusOfAnUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RecentConversationsSpReturnModel> GetRecentConversations(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SearchSharedorUnsharedchannelsOutputModel> GetSharedorUnsharedchannels(SearchSharedorUnsharedchannelsInputModel searchSharedorUnsharedchannelsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}