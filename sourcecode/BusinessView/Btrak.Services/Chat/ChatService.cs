using Btrak.Dapper.Dal.Repositories;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models;
using Btrak.Models.Chat;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.Chat;
using Btrak.Services.Helpers;
using Btrak.Models.UserStory;
using BTrak.Common.Texts;
using Btrak.Services.PubNub;
using Newtonsoft.Json;
using MessageReactionModel = Btrak.Models.Chat.MessageReactions;
using System.Web;
using Btrak.Services.FileUploadDownload;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;
using Btrak.Models.SystemManagement;
using Hangfire;
using System.Configuration;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models.MasterData;
using Btrak.Services.Email;
// ReSharper disable PossibleInvalidOperationException
// ReSharper disable SpecifyACultureInStringConversionExplicitly
// ReSharper disable AccessToModifiedClosure

namespace Btrak.Services.Chat
{
    public class ChatService : IChatService
    {
        private readonly MessageRepository _messageRepository;
        private readonly ChannelRepository _channelRepository;
        private readonly ChannelMemberRepository _channelMemberRepository;
        private readonly IAuditService _auditService;
        private readonly UserStoryRepository _userStoryRepository;
        private readonly UserRepository _userRepository;
        private readonly IPubNubService _pubNubService;
        private readonly IFileStoreService _fileStoreService;
        private GoalRepository _goalRepository;
        private readonly MasterDataManagementRepository _masterManagementRepository;
        private ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        public ChatService(MessageRepository messageRepository, ChannelRepository channelRepository, ChannelMemberRepository channelMemberRepository, IAuditService auditService, UserStoryRepository userStoryRepository, UserRepository userRepository, IPubNubService pubNubService, IFileStoreService fileStoreService, GoalRepository goalRepository, ICompanyStructureService companyStructureService, MasterDataManagementRepository masterManagementRepository, IEmailService emailService)
        {
            _messageRepository = messageRepository;
            _channelRepository = channelRepository;
            _channelMemberRepository = channelMemberRepository;
            _auditService = auditService;
            _userStoryRepository = userStoryRepository;
            _userRepository = userRepository;
            _pubNubService = pubNubService;
            _fileStoreService = fileStoreService;
            _goalRepository = goalRepository;
            _companyStructureService = companyStructureService;
            _masterManagementRepository = masterManagementRepository;
            _emailService = emailService;
        }

        public IList<MessageApiReturnModel> GetChannelChat(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetChannelChat", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<MessageSpReturnModel> chat = _channelRepository.SelectChannelMessages(messageSearchInputModel, loggedInContext, validationMessages);

            if (chat != null && chat.ToList().Count > 0)
            {
                List<MessageApiReturnModel> channelChat = chat.Select(ConvertToMessageApiReturnModel).ToList();

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetChannelChat", "ChatService"));

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {
                        if (messageSearchInputModel.ParentMessageId == null &&
                            !messageSearchInputModel.IsForSingleMessageDetails)
                        {
                            var messageReadReceiptInputModel = new MessageReadReceiptInputModel
                            {
                                SenderuserId = (Guid)messageSearchInputModel.ChannelId,
                                MessageId = (Guid)channelChat[0].Id,
                                MessageDateTime = channelChat[0].MessageDateTime,
                                IsChannel = true
                            };

                            _channelRepository.UpsertMessageReadReceipt(messageReadReceiptInputModel, loggedInContext,
                                validationMessages);

                        }
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetChannelChat", "ChatService ", exception.Message), exception);

                    }
                });

                return channelChat;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetChannelChat", "ChatService"));

            return null;
        }

        public IList<MessageApiReturnModel> GetPinnedOrStaredMessages(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetChannelChat", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<MessageSpReturnModel> chat = _channelRepository.GetPinnedOrStaredMessages(messageSearchInputModel, loggedInContext, validationMessages);

            if (chat != null && chat.ToList().Count > 0)
            {
                List<MessageApiReturnModel> channelChat = chat.Select(ConvertToMessageApiReturnModel).ToList();

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetChannelChat", "ChatService"));

                return channelChat;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetChannelChat", "ChatService"));

            return null;
        }

        public IList<MessageApiReturnModel> GetPersonalChat(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPersonalChat", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<MessageSpReturnModel> chat = _messageRepository.SelectMessagesBetweenTwoUsers(messageSearchInputModel, loggedInContext, validationMessages);

            if (chat != null && chat.ToList().Count > 0)
            {
                List<MessageApiReturnModel> chatBetweenUsers = chat.Select(ConvertToMessageApiReturnModel).ToList();

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPersonalChat", "ChatService"));

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {
                        if (!messageSearchInputModel.IsForSingleMessageDetails &&
                            messageSearchInputModel.ParentMessageId == null)
                        {
                            var messageReadReceiptInputModel = new MessageReadReceiptInputModel
                            {
                                SenderuserId = (Guid)messageSearchInputModel.UserId,
                                MessageId = (Guid)chatBetweenUsers[0].Id,
                                MessageDateTime = chatBetweenUsers[0].MessageDateTime,
                                IsChannel = false
                            };

                            _channelRepository.UpsertMessageReadReceipt(messageReadReceiptInputModel, loggedInContext,
                                validationMessages);

                        }
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPersonalChat", "ChatService ", exception.Message), exception);

                    }
                });

                return chatBetweenUsers;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPersonalChat", "ChatService"));

            return null;
        }

        public UpsertMessageOutputModel InsertMessageInUserStoryChannel(Guid? channelId, LoggedInContext loggedInContext, MessageDto activityMessageDto = null, bool? ismember = null, bool isFromUserStoryChannel = false)
        {
            try
            {
                UserStoryHistoryModel userStoryHistoryModel = new UserStoryHistoryModel();
                MessageUpsertInputModel messageUpsertInputModel = new MessageUpsertInputModel();

                if (channelId != null)
                {
                    if (activityMessageDto == null)
                    {
                        List<UserStoryHistoryModel> userStoryHistoryList = _userStoryRepository
                            .GetUserStoryHistory((Guid)channelId, loggedInContext, new List<ValidationMessage>())
                            .OrderByDescending(x => x.CreatedDateTime).ToList();
                        if (userStoryHistoryList.Count > 0 &&
                            userStoryHistoryList[0].Description.Contains("IsForQaChange"))
                        {
                            if (userStoryHistoryList.Count > 1)
                                userStoryHistoryModel = userStoryHistoryList[1];
                        }
                        else
                        {
                            userStoryHistoryModel = userStoryHistoryList.FirstOrDefault();
                        }

                        BuildingDescription(new List<UserStoryHistoryModel>() { userStoryHistoryModel });

                        if (userStoryHistoryModel != null)
                        {
                            messageUpsertInputModel.ChannelId = channelId;
                            messageUpsertInputModel.SenderUserId = loggedInContext.LoggedInUserId;
                            messageUpsertInputModel.MessageType = "Text";
                            messageUpsertInputModel.IsActivityMessage = true;
                            string textMessage = Encrypt(userStoryHistoryModel.Description);
                            messageUpsertInputModel.TextMessage = textMessage;
                            messageUpsertInputModel.Id = Guid.NewGuid();
                            messageUpsertInputModel.IsStarred = null;
                            messageUpsertInputModel.IsFromBackend = true;
                        }
                    }
                    else
                    {
                        messageUpsertInputModel.ChannelId = channelId;
                        messageUpsertInputModel.SenderUserId = loggedInContext.LoggedInUserId;
                        messageUpsertInputModel.MessageType = "Text";
                        messageUpsertInputModel.IsActivityMessage = true;
                        string textMessage = Encrypt(activityMessageDto.TextMessage);
                        messageUpsertInputModel.TextMessage = textMessage;
                        messageUpsertInputModel.Id = Guid.NewGuid();
                    }
                }

                if (messageUpsertInputModel.Id != null && messageUpsertInputModel.Id != Guid.Empty)
                {
                    messageUpsertInputModel.IsFromBackend = activityMessageDto != null ? Convert.ToBoolean(activityMessageDto.IsFromBackend) : messageUpsertInputModel.IsFromBackend;
                    _messageRepository.MessagesInsert(messageUpsertInputModel, loggedInContext, new List<ValidationMessage>());


                    if (ismember != null)
                    {
                        var messageDtoValues = new MessageDto()
                        {
                            IsFromRemoveMember = !Convert.ToBoolean(ismember),
                            IsChannelMember = ismember,
                            IsFromAddMember = Convert.ToBoolean(ismember),
                            ChannelId = channelId,
                            SenderUserId = loggedInContext.LoggedInUserId,
                            FromUserId = loggedInContext.LoggedInUserId,
                        };

                        if (ismember == true)
                        {
                            _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(messageDtoValues), new List<string>() { string.Format("ChannelUpdates-{0}", loggedInContext.CompanyGuid) }, loggedInContext);
                        }
                        else
                        {
                            _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(messageDtoValues), new List<string>() { string.Format("{0}-{1}", loggedInContext.CompanyGuid, channelId) }, loggedInContext);
                        }
                    }

                    var channelDetails = GetUserChannels(new ChannelSearchInputModel { ChannelId = channelId },
                        loggedInContext, new List<ValidationMessage>());

                    var senderName = _userRepository.GetAllUsersForSlack(loggedInContext)?.FirstOrDefault(x => x.Id == loggedInContext.LoggedInUserId)?.FullName;

                    var messageDto = new MessageDto()
                    {
                        ChannelId = channelId,
                        SenderUserId = loggedInContext.LoggedInUserId,
                        MessageType = AppConstants.MessageType,
                        TextMessage = activityMessageDto == null ? userStoryHistoryModel?.Description : activityMessageDto.TextMessage,
                        IsActivityMessage = true,
                        MessageReceiveDate = DateTime.UtcNow.ToString(),
                        MessageDateTime = DateTime.UtcNow,
                        Id = messageUpsertInputModel.Id,
                        RefreshChannels = userStoryHistoryModel != null && (isFromUserStoryChannel ? false : activityMessageDto == null ? userStoryHistoryModel.Description.Contains("Created") : activityMessageDto.TextMessage.Contains("Created")),
                        SenderName = senderName,
                        ChannelName = channelDetails?[0]?.ChannelName ?? senderName,
                        IsFromBackend = Convert.ToBoolean(activityMessageDto?.IsFromBackend),
                        FromUserId = loggedInContext.LoggedInUserId
                    };

                    var serializesdData = JsonConvert.SerializeObject(messageDto);

                    _pubNubService.PublishMessageToChannel(serializesdData, new List<string>() { string.Format("{0}-{1}", loggedInContext.CompanyGuid, channelId) }, loggedInContext);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertMessageInUserStoryChannel", "ChatService ", exception.Message), exception);

            }

            return null;
        }

        public UpsertMessageOutputModel SendMessageToChannelOrUser(MessageUpsertInputModel individualMessageModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendIndividualMessage", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            individualMessageModel.TextMessage = individualMessageModel.TextMessage?.Trim();
            individualMessageModel.MessageType = individualMessageModel.MessageType?.Trim();

            _auditService.SaveAudit(AppCommandConstants.SendMessagesToUserOrChannelCommandId, individualMessageModel, loggedInContext);

            string textMessage = Encrypt(individualMessageModel.TextMessage);
            individualMessageModel.TextMessage = textMessage;

            if (individualMessageModel.TaggedMembersIds?.Count > 0)
                individualMessageModel.TaggedMembersIdsXml =
                    Utilities.GetXmlFromObject(individualMessageModel.TaggedMembersIds);

            UpsertMessageOutputModel messagesDetails = _messageRepository.MessagesInsert(individualMessageModel, loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendIndividualMessage", "ChatService"));

            return messagesDetails;
        }

        public IList<MessageCountModel> GetMessagesCount(Guid userId)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMessagesCount", "ChatService"));

            try
            {
                var unreadMessageUsers = _messageRepository.GetMessagesCount(userId);

                if (unreadMessageUsers != null && unreadMessageUsers.ToList().Count > 0)
                {
                    var messageSendingUsers = unreadMessageUsers.Select(ConvertMessagesListSpEntityToMessageCountModel).ToList();

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMessagesCount", "ChatService"));

                    return messageSendingUsers;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMessagesCount", "ChatService ", exception.Message), exception);

            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMessagesCount", "ChatService"));

            return null;
        }

        private MessageCountModel ConvertMessagesListSpEntityToMessageCountModel(MessagesListSpEntity messagesListSpEntity)
        {
            return new MessageCountModel
            {
                ChannelId = messagesListSpEntity.ChannelId,
                MessageCount = messagesListSpEntity.MessageCount,
                ReceiverId = messagesListSpEntity.ReceiverUserId,
                SenderId = messagesListSpEntity.SenderUserId
            };
        }

        public Guid? UpsertChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateNewChannel", "ChatService"));

            LoggingManager.Debug(channelModel.ToString());

            IList<ChannelApiReturnModel> oldChannelDetails = new List<ChannelApiReturnModel>();

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            channelModel.ChannelName = channelModel.ChannelName?.Trim();
            channelModel.ChannelImage = channelModel.ChannelImage?.Trim();

            _auditService.SaveAudit(AppCommandConstants.UpsertChannelCommandId, channelModel, loggedInContext);

            if (!ChatValidations.ValidateUpsertChannel(channelModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (channelModel.ChannelId != null && channelModel.ChannelId != Guid.Empty)
            {
                oldChannelDetails = GetUserChannels(new ChannelSearchInputModel { ChannelId = channelModel.ChannelId, IsDeleted = false }, loggedInContext, validationMessages);
            }

            Guid? channelId = _channelRepository.UpsertChannel(channelModel, loggedInContext, validationMessages);

            if (channelId != null && channelId != Guid.Empty)
            {
                if (oldChannelDetails != null && oldChannelDetails.Count > 0)
                {
                    if (channelModel.IsFromProjectArchive != null && channelModel.IsFromProjectArchive == false)
                    {
                        //Unarchiving the project channel
                        _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(new MessageDto { RefreshChannels = true, ChannelId = channelId, FromUserId = loggedInContext.LoggedInUserId, SenderUserId = loggedInContext.LoggedInUserId }), new List<string>() { string.Format("ChannelUpdates-{0}", loggedInContext.CompanyGuid) }, loggedInContext);

                        TaskWrapper.ExecuteFunctionInNewThread(async () =>
                        {
                            await Task.Delay(TimeSpan.FromSeconds(2));
                            var channelDetails = GetUserChannels(new ChannelSearchInputModel { ChannelId = channelModel.ChannelId, IsDeleted = false }, loggedInContext, validationMessages);
                            var newChannelDetails = channelDetails.FirstOrDefault(x => x.Id == channelModel.ChannelId);
                            if (newChannelDetails != null)
                            {
                                var activityMessage = $"{newChannelDetails.ChannelName} unarchived";

                                var userDetails = _userRepository.GetSingleUserDetails(loggedInContext.LoggedInUserId);

                                var messageModel = GetActivityMessageModel(activityMessage, channelModel);

                                if (messageModel != null)
                                {
                                    messageModel.SenderUserId = loggedInContext.LoggedInUserId;
                                    messageModel.FromUserId = loggedInContext.LoggedInUserId;
                                    messageModel.SenderName = userDetails.FullName;
                                    messageModel.SenderProfileImage = userDetails.ProfileImage;
                                    messageModel.body = messageModel.TextMessage;
                                    messageModel.title = $"New message from {messageModel.SenderName}";
                                    if (messageModel.ChannelId != null)
                                        messageModel.title += $" in {newChannelDetails.ChannelName}";

                                    PublishAndInsertActivityMessage(messageModel, loggedInContext);
                                }
                            }
                        });
                    }
                    else if (channelModel.IsFromChannelImageUpdate)
                    {
                        _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(new MessageDto
                        {
                            SenderUserId = loggedInContext.LoggedInUserId,
                            ChannelId = channelId,
                            ChannelName = channelModel.ChannelName,
                            FromUserId = loggedInContext.LoggedInUserId,
                            FromChannelImage = true,
                        }), new List<string>() { string.Format("{0}-{1}", loggedInContext.CompanyGuid, channelId) }, loggedInContext);
                    }
                    else
                    {
                        var message = new MessageDto
                        {
                            ChannelId = channelId,
                            SenderUserId = loggedInContext.LoggedInUserId,
                            FromUserId = loggedInContext.LoggedInUserId
                        };

                        if (channelModel.IsDeleted)
                        {
                            message.IsFromChannelArchive = true;
                        }
                        else
                        {
                            message.IsFromChannelRename = true;
                        }

                        _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(message), new List<string>() { string.Format("{0}-{1}", loggedInContext.CompanyGuid, channelId) }, loggedInContext);

                        if (message.IsFromChannelRename)
                        {
                            TaskWrapper.ExecuteFunctionInNewThread(async () =>
                            {
                                await Task.Delay(TimeSpan.FromSeconds(2));
                                var channelDetails = GetUserChannels(new ChannelSearchInputModel { ChannelId = channelModel.ChannelId, IsDeleted = false }, loggedInContext, validationMessages);
                                var newChannelDetails = channelDetails.FirstOrDefault(x => x.Id == channelModel.ChannelId);
                                if (newChannelDetails != null)
                                {
                                    if (oldChannelDetails[0].ChannelName != newChannelDetails.ChannelName)
                                    {
                                        var activityMessage = $"Channel renamed from {oldChannelDetails[0].ChannelName} to {newChannelDetails.ChannelName}";

                                        var messageModel = GetActivityMessageModel(activityMessage, channelModel);

                                        var userDetails = _userRepository.GetSingleUserDetails(loggedInContext.LoggedInUserId);

                                        if (messageModel != null)
                                        {
                                            messageModel.SenderUserId = loggedInContext.LoggedInUserId;
                                            messageModel.FromUserId = loggedInContext.LoggedInUserId;
                                            messageModel.SenderName = userDetails.FullName;
                                            messageModel.SenderProfileImage = userDetails.ProfileImage;
                                            messageModel.body = messageModel.TextMessage;
                                            messageModel.title = $"New message from {messageModel.SenderName}";
                                            if (messageModel.ChannelId != null)
                                                messageModel.title += $" in {newChannelDetails.ChannelName}";

                                            PublishAndInsertActivityMessage(messageModel, loggedInContext);
                                        }
                                    }
                                }
                            });
                        }
                    }
                }
                else
                {   //New channel
                    if (channelModel.ChannelMemberModel != null && channelModel.ChannelMemberModel.Count > 0 && (channelModel.ChannelId == null || channelModel.ChannelId == Guid.Empty) && !channelModel.IsFromChannelImageUpdate)
                    {
                        string channelMembersListXml = Utilities.ConvertIntoListXml(channelModel.ChannelMemberModel);
                        channelModel.ChannelMemberXml = channelMembersListXml;
                        channelModel.ChannelId = channelId;
                        Guid? channelGuid = _channelMemberRepository.Upsert(channelModel, loggedInContext, validationMessages);

                        _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(new MessageDto { RefreshChannels = true, ChannelId = channelGuid, FromUserId = loggedInContext.LoggedInUserId, SenderUserId = loggedInContext.LoggedInUserId }), new List<string>() { string.Format("ChannelUpdates-{0}", loggedInContext.CompanyGuid) }, loggedInContext);

                        TaskWrapper.ExecuteFunctionInNewThread(async () =>
                        {
                            await Task.Delay(TimeSpan.FromSeconds(2));
                            GenerateAndInsertChannelActivityMessage(loggedInContext, channelModel, fromAddMembersToChannel: null);
                        });
                    }
                }
            }

            LoggingManager.Debug(channelId?.ToString());

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateNewChannel", "ChatService"));

            return channelId;
        }

        public Guid? CreateNewChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateNewChannel", "ChatService"));

            LoggingManager.Debug(channelModel.ToString());

            channelModel.ChannelName = channelModel.ChannelName?.Trim();
            channelModel.ChannelImage = channelModel.ChannelImage?.Trim();

            _auditService.SaveAudit(AppCommandConstants.CreateNewChannelCommandId, channelModel, loggedInContext);

            if (!ChatValidations.ValidateNewChannel(channelModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? channel = _channelRepository.UpsertChannel(channelModel, loggedInContext, validationMessages);

            if (channel != null && channel != Guid.Empty)
            {
                channelModel.ChannelId = channel;

                if (channelModel.ChannelId != null && channelModel.ChannelId != Guid.Empty && channelModel.ChannelMemberModel.FirstOrDefault(x => x.MemberUserId != loggedInContext.LoggedInUserId) == null)
                {
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        try
                        {
                            var messageDto = GetActivityMessageDto(channelModel.ChannelName, channelModel.ChannelId, true, false, false,
                                "Channel " + channelModel.ChannelName + " is created.");
                            _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(messageDto), new List<string>(), loggedInContext);

                            InsertMessageInUserStoryChannel(channelModel.ChannelId, loggedInContext, messageDto);
                        }
                        catch (Exception exception)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateNewChannel", "ChatService ", exception.Message), exception);

                        }
                    });
                }

                channelModel.ChannelId = channel;

                if (channelModel.ChannelMemberModel != null && channelModel.ChannelMemberModel.Count > 0)
                {
                    string channelMembersListXml = Utilities.ConvertIntoListXml(channelModel.ChannelMemberModel);
                    channelModel.ChannelMemberXml = channelMembersListXml;

                    Guid? channelGuid = _channelMemberRepository.Upsert(channelModel, loggedInContext, validationMessages);

                    InsertChannelActivityMessages(channelGuid, loggedInContext, validationMessages, channelModel);
                }
            }

            LoggingManager.Debug(channel?.ToString());

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateNewChannel", "ChatService"));

            return channel;
        }

        public void InsertChannelActivityMessages(Guid? channelGuid, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, ChannelUpsertInputModel channelModel, bool? isMemberAdded = null)
        {
            try
            {
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {
                        string messageString;

                        if (channelGuid != null && channelGuid != Guid.Empty)
                        {
                            var userDetails = _userRepository.GetAllUsersForSlack(loggedInContext);

                            if (userDetails?.Count > 0)
                            {
                                string usersString;

                                var channelMembers = channelModel.ChannelMemberModel.Where(x => x.MemberUserId != loggedInContext.LoggedInUserId).ToList();

                                if (channelMembers.Count > 0)
                                {
                                    if (channelMembers.Count > 1)
                                    {
                                        usersString = userDetails.FirstOrDefault(x => x.Id == channelModel.ChannelMemberModel?.FirstOrDefault()?.MemberUserId)?.FullName + " along with " + (channelMembers.Count - 1) + " others.";
                                    }
                                    else
                                    {
                                        usersString = userDetails.FirstOrDefault(x => x.Id == channelMembers.FirstOrDefault()?.MemberUserId)?.FullName;
                                    }

                                    messageString = isMemberAdded == null ? "Created " + channelModel.ChannelName + " and " + "added " + usersString : isMemberAdded == true ? "Added " + usersString : "Removed " + usersString;
                                }

                                else
                                {
                                    messageString = "Created " + channelModel.ChannelName;
                                }

                                var messageDto = GetActivityMessageDto(channelModel.ChannelName, channelGuid, false, false, true, messageString);


                                Task.Run(async () =>
                                {
                                    try
                                    {
                                        messageDto.IsFromBackend = channelModel.IsFromBackend;
                                        await Task.Delay(2000);
                                        InsertMessageInUserStoryChannel(channelGuid, loggedInContext, messageDto, isMemberAdded, true);
                                    }
                                    catch (Exception exception)
                                    {
                                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertChannelActivityMessages", "ChatService ", exception.Message), exception);

                                    }
                                });
                            }
                        }
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertChannelActivityMessages", "ChatService ", exception.Message), exception);

                    }
                });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertChannelActivityMessages", "ChatService ", exception.Message), exception);

            }
        }

        private MessageDto GetActivityMessageDto(string channelName, Guid? channelId, bool ischannelRefres, bool isChannelEdited, bool isChannelMember, string textMessage)
        {

            return new MessageDto
            {
                ChannelId = channelId,
                RefreshChannels = ischannelRefres,
                TextMessage = textMessage,
                ChannelName = channelName,
                SenderName = channelName,
                IsFromChannelRename = isChannelEdited,
                IsChannelMember = isChannelMember,
            };
        }

        public Guid? UpdateChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateChannel", "ChatService"));

            LoggingManager.Debug(channelModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            channelModel.ChannelName = channelModel.ChannelName?.Trim();
            channelModel.ChannelImage = channelModel.ChannelImage?.Trim();

            _auditService.SaveAudit(AppCommandConstants.UpdateChannelCommandId, channelModel, loggedInContext);

            if (!ChatValidations.ValidateUpdateChannel(channelModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? channel = _channelRepository.UpsertChannel(channelModel, loggedInContext, validationMessages);

            LoggingManager.Debug(channel?.ToString());

            return channel;
        }

        public IList<ChannelApiReturnModel> GetUserChannels(ChannelSearchInputModel channelSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserChannels", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ChannelApiReturnModel> userChannels = _channelRepository.UserChannels(channelSearchInputModel, loggedInContext, validationMessages);

            if (userChannels != null && userChannels.Count > 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserChannels", "ChatService"));

                return userChannels;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserChannels", "ChatService"));

            return null;
        }

        public bool ArchiveChannel(Guid channelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveChannel", "ChatService"));

            LoggingManager.Debug(channelId.ToString());

            if (!ChatValidations.ValidateArchiveChannelByChannelId(channelId, loggedInContext, validationMessages))
            {
                return false;
            }

            bool isArchived = _channelRepository.ArchiveChannel(channelId, loggedInContext, validationMessages);

            LoggingManager.Debug(isArchived.ToString());

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveChannel", "ChatService"));

            return isArchived;
        }

        public Guid? AddEmployeesToChannel(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddEmployeesToChannel", "ChatService"));

            channelModel.ChannelName = channelModel.ChannelName?.Trim();
            channelModel.ChannelImage = channelModel.ChannelImage?.Trim();

            if (channelModel.ChannelMemberModel != null && channelModel.ChannelMemberModel.Count > 0)
            {
                if (!ChatValidations.ValidateAddEmployeesToChannel(channelModel, loggedInContext, validationMessages))
                {
                    return null;
                }

                _auditService.SaveAudit(AppCommandConstants.AddEmployeesToChannelCommandId, channelModel, loggedInContext);

                string channelMembersListXml = Utilities.ConvertIntoListXml(channelModel.ChannelMemberModel);
                channelModel.ChannelMemberXml = channelMembersListXml;

                Guid? channelId = _channelMemberRepository.Upsert(channelModel, loggedInContext, validationMessages);

                if (channelId != null && channelId != Guid.Empty)
                {
                    var message = new MessageDto
                    {
                        RefreshChannels = false,
                        IsFromChannelRename = false,
                        IsFromChannelArchive = false,
                        IsFromAddMember = true,
                        IsFromRemoveMember = false,
                        SenderUserId = loggedInContext.LoggedInUserId,
                        ChannelId = channelId,
                        FromUserId = loggedInContext.LoggedInUserId
                    };

                    _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(message), new List<string>() { string.Format("ChannelUpdates-{0}", loggedInContext.CompanyGuid) }, loggedInContext);

                    TaskWrapper.ExecuteFunctionInNewThread(async () =>
                    {
                        await Task.Delay(TimeSpan.FromSeconds(2));
                        GenerateAndInsertChannelActivityMessage(loggedInContext, channelModel, fromAddMembersToChannel: true);
                    });
                }

                return channelId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddEmployeesToChannel", "ChatService"));

            return null;
        }

        public IList<ChannelMemberApiReturnModel> GetChannelMembers(ChannelMemberSearchInputModel channelMemberSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetChannelMembers", "ChatService"));

            if (channelMemberSearchInputModel.ProjectId == null && !ChatValidations.ValidateGetChannelMembers(channelMemberSearchInputModel.ChannelId, loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetChannelMembersCommandId, channelMemberSearchInputModel, loggedInContext);

            IList<ChannelMemberApiReturnModel> members = !channelMemberSearchInputModel.IsAddMemberToChannel ? _channelRepository.ChannelUsers(channelMemberSearchInputModel, loggedInContext, validationMessages) : _channelRepository.GetUsersForChannel(channelMemberSearchInputModel, loggedInContext, validationMessages);

            if (members != null && members.ToList().Count > 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetChannelMembers", "ChatService"));

                return members;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetChannelMembers", "ChatService"));

            return new List<ChannelMemberApiReturnModel>();
        }

        public List<LatestPunchCardStatusOfAnUserApiReturnModel> GetLatestPunchCardStatusOfAnUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLatestPunchCardStatusOfAnUser", "ChatService"));

            _auditService.SaveAudit(AppCommandConstants.GetChannelMembersCommandId, loggedInContext.LoggedInUserId, loggedInContext);

            List<LatestPunchCardStatusOfAnUserApiReturnModel> usersList = _channelRepository.GetLatestPunchCardStatusOfAnUser(loggedInContext, validationMessages);

            return usersList;
        }

        public List<RecentConversationsSpReturnModel> GetRecentConversations(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRecentConversations", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<RecentConversationsSpReturnModel> Conversations = _channelRepository.GetRecentConversations(loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentConversations", "ChatService"));

            return Conversations;
        }

        public List<SearchSharedorUnsharedchannelsOutputModel> GetSharedorUnsharedchannels(SearchSharedorUnsharedchannelsInputModel searchSharedorUnsharedchannelsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSharedorUnsharedchannels", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<SearchSharedorUnsharedchannelsOutputModel> channels = _channelRepository.GetSharedorUnsharedchannels(searchSharedorUnsharedchannelsInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSharedorUnsharedchannels", "ChatService"));

            return channels;
        }

        public Guid? ArchiveChannelMembers(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveChannelMembers", "ChatService"));

            LoggingManager.Debug(channelModel.ToString());

            MessageUpsertInputModel messageUpsertInputModel = new MessageUpsertInputModel();

            if (!ChatValidations.ValidateArchiveChannelMembers(channelModel.ChannelId, loggedInContext, validationMessages))
            {
                return null;
            }

            channelModel.ChannelName = channelModel.ChannelName?.Trim();
            channelModel.ChannelImage = channelModel.ChannelImage?.Trim();

            _auditService.SaveAudit(AppCommandConstants.ArchiveChannelMembersCommandId, channelModel, loggedInContext);

            if (channelModel.ChannelMemberModel != null && channelModel.ChannelMemberModel.Count > 0)
            {
                string channelMembersListXml = Utilities.ConvertIntoListXml(channelModel.ChannelMemberModel);

                channelModel.ChannelMemberXml = channelMembersListXml;

                if (channelModel.ChannelMemberModel.Any(x => x.MemberUserId == loggedInContext.LoggedInUserId) && channelModel.IsDeleted == true)
                {
                    try
                    {
                        messageUpsertInputModel = new MessageUpsertInputModel
                        {
                            Id = Guid.NewGuid(),
                            ChannelId = channelModel.ChannelId,
                            SenderUserId = loggedInContext.LoggedInUserId,
                            IsStarred = null,
                            MessageType = AppConstants.MessageType,
                            IsFromBackend = true,
                            IsActivityMessage = true
                        };

                        var userDetails = _userRepository.GetSingleUserDetails((Guid)channelModel.ChannelMemberModel?.FirstOrDefault()?.MemberUserId);

                        var activityMessageString = $"{userDetails?.FullName} left";

                        string textMessage = Encrypt(activityMessageString);

                        messageUpsertInputModel.TextMessage = textMessage;

                        _messageRepository.MessagesInsert(messageUpsertInputModel, loggedInContext, new List<ValidationMessage>());
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveChannelMembers", "ChatService ", exception.Message), exception);

                    }
                }

                Guid? channelId = _channelMemberRepository.Upsert(channelModel, loggedInContext, validationMessages);

                if (channelId != null && channelId != Guid.Empty)
                {
                    var message = new MessageDto
                    {
                        RefreshChannels = false,
                        IsFromChannelRename = false,
                        IsFromChannelArchive = false,
                        IsFromAddMember = false,
                        IsFromRemoveMember = true,
                        SenderUserId = loggedInContext.LoggedInUserId,
                        ChannelId = channelId,
                        FromUserId = loggedInContext.LoggedInUserId
                    };

                    _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(message), new List<string>() { string.Format("{0}-{1}", loggedInContext.CompanyGuid, channelId) }, loggedInContext);

                    TaskWrapper.ExecuteFunctionInNewThread(async () =>
                    {
                        await Task.Delay(TimeSpan.FromSeconds(2));
                        GenerateAndInsertChannelActivityMessage(loggedInContext, channelModel, fromAddMembersToChannel: false, messageUpsertInputModel: messageUpsertInputModel);
                    });
                }
                else
                {
                    messageUpsertInputModel.IsDeleted = true;
                    _messageRepository.MessagesInsert(messageUpsertInputModel, loggedInContext, validationMessages);
                }

                return channelId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveChannelMembers", "ChatService"));

            return null;
        }

        public void AddOrUpdateUserFcmDetails(string userId, string deviceUniqueId, string fcmToken, bool isRemove, bool isFromBTrakMobile, LoggedInContext loggedInContext)
        {
            try
            {
                _messageRepository.AddOrUpdateUserFcmTokenDetails(userId, deviceUniqueId, fcmToken, isRemove, isFromBTrakMobile, loggedInContext);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddOrUpdateUserFcmDetails", "ChatService ", ex.Message), ex);

            }
        }

        public List<RecentIndividualConversationSpReturnModel> GetRecentIndividualMessages(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRecentIndividualMessages", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<RecentIndividualConversationSpReturnModel> messages = _channelRepository.GetRecentIndividualMessages(loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentIndividualMessages", "ChatService"));

            return messages;
        }

        public List<RecentChannelConversationApiReturnModel> GetRecentChannelMessages(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRecentChannelMessages", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<RecentChannelConversationApiReturnModel> channels = _channelRepository.GetRecentChannelMessages(loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentChannelMessages", "ChatService"));

            return channels;
        }

        private string Encrypt(string textToEncrypt)
        {
            try
            {
                if (!string.IsNullOrEmpty(textToEncrypt) && !string.IsNullOrWhiteSpace(textToEncrypt))
                {
                    string toReturn;
                    string _key = "ay$a5%&jwrtmnh;lasjdf98787";
                    string _iv = "abc@98797hjkas$&asd(*$%";

                    using (MemoryStream ms = new MemoryStream())
                    {
                        byte[] ivByte = Encoding.UTF8.GetBytes(_iv.Substring(0, 8));
                        byte[] keybyte = Encoding.UTF8.GetBytes(_key.Substring(0, 8));
                        byte[] inputbyteArray = Encoding.UTF8.GetBytes(textToEncrypt);

                        using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
                        {
                            using (CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(keybyte, ivByte),
                                CryptoStreamMode.Write))
                            {
                                cs.Write(inputbyteArray, 0, inputbyteArray.Length);
                                cs.FlushFinalBlock();
                                toReturn = Convert.ToBase64String(ms.ToArray());
                            }
                        }
                        ms.Flush();
                    }

                    return toReturn;
                }

                return string.Empty;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Encrypt", "ChatService ", exception.Message), exception);

                return null;
            }
        }

        private string Decrypt(string textToDecrypt)
        {
            try
            {
                if (!string.IsNullOrWhiteSpace(textToDecrypt) && !string.IsNullOrEmpty(textToDecrypt))
                {
                    string toReturn;
                    string _key = "ay$a5%&jwrtmnh;lasjdf98787";
                    string _iv = "abc@98797hjkas$&asd(*$%";


                    using (MemoryStream ms = new MemoryStream())
                    {
                        byte[] ivByte = Encoding.UTF8.GetBytes(_iv.Substring(0, 8));
                        byte[] keybyte = Encoding.UTF8.GetBytes(_key.Substring(0, 8));
                        var inputbyteArray = Convert.FromBase64String(textToDecrypt.Replace(" ", "+"));
                        using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
                        {
                            using (CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(keybyte, ivByte), CryptoStreamMode.Write))
                            {
                                cs.Write(inputbyteArray, 0, inputbyteArray.Length);
                                cs.FlushFinalBlock();
                                Encoding encoding = Encoding.UTF8;
                                toReturn = encoding.GetString(ms.ToArray());
                            }
                        }
                        ms.Flush();
                    }

                    return toReturn;
                }

                return string.Empty;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Decrypt", "ChatService ", exception.Message), exception);

                return null;
            }
        }

        public List<MessageShareSpReturnModel> ShareMessageToContacts(MessageShareModel messageShareModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ShareMessageToContacts", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            messageShareModel.MessagesXml = Utilities.GetXmlFromObject(messageShareModel.Messages);

            List<MessageShareSpReturnModel> messageShareSpReturnModels = _channelRepository.ShareMessageToContacts(messageShareModel, loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ShareMessageToContacts", "ChatService"));

            return messageShareSpReturnModels;
        }

        public bool UpsertMuteOrStarContact(MuteOrStarContactModel muteOrStarContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertMuteOrStarContact", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return false;
            }

            bool result = _channelRepository.UpsertMuteOrStarContact(muteOrStarContactModel, loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertMuteOrStarContact", "ChatService"));

            return result;
        }

        public List<StarredMessagesApiReturnModel> GetAllStarredMessages(MessageSearchInputModel messageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllStarredMessages", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var result = _channelRepository.GetAllStarredMessages(messageSearchInputModel, loggedInContext, validationMessages);

            result.ForEach(x =>
            {
                x.TaggedMembersIds = string.IsNullOrEmpty(x.TaggedMembersXml) ? null : Utilities.GetObjectFromXml<Guid?>(x.TaggedMembersXml, "ArrayOfGuid");
                x.Message = Decrypt(x.Message);

                if (string.IsNullOrEmpty(x.ReactionsJson)) return;

                x.Reactions = JsonConvert.DeserializeObject<List<Reactions>>(x.ReactionsJson);
                if (x.Reactions.Count > 0)
                    x.Reactions.ForEach(y => y.Reaction = Decrypt(y.Reaction));
            });

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllStarredMessages", "ChatService"));

            return result;
        }

        public List<SharedFilesApiReturnModel> GetSharedFiles(SharedFilesSearchInputModel sharedFilesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSharedFiles", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var result = _messageRepository.GetSharedFiles(sharedFilesSearchInputModel, loggedInContext);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSharedFiles", "ChatService"));

            return result;
        }

        public void SendPublicMessageToChannel(WebHookInputModel webHookInputModel)
        {

            LoggingManager.Debug("Entered-SendPublicMessageToChannel");
            try
            {
                Guid channelId = new Guid(webHookInputModel.WebUrl.Substring(webHookInputModel.WebUrl.IndexOf('=') + 1));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                ChannelSearchInputModel channelSearchInputModel = new ChannelSearchInputModel
                {
                    ChannelId = channelId,
                    IsDeleted = false
                };

                LoggedInContext loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = webHookInputModel.SenderId
                };

                ChannelApiReturnModel channelDetails = _channelRepository.UserChannels(channelSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();

                if (channelDetails != null)
                {
                    var newMessageId = Guid.NewGuid();

                    var userDetails = _userRepository.GetSingleUserDetails(loggedInContext.LoggedInUserId);

                    MessageDto messageDto = new MessageDto
                    {
                        Id = newMessageId,
                        ChannelId = channelId,
                        ChannelName = channelDetails.ChannelName,
                        SenderUserId = loggedInContext.LoggedInUserId,
                        ReportMessage = webHookInputModel.ReportMessage,
                        MessageType = "Report",
                        UpdatedDateTime = null,
                        MessageDateTime = DateTime.UtcNow,
                        FromUserId = loggedInContext.LoggedInUserId,
                        SenderName = userDetails.FullName,
                        SenderProfileImage = userDetails.ProfileImage,
                        body = $"{userDetails.FullName}'s status report",
                        title = $"New message from {userDetails.FullName} in {channelDetails.ChannelName}"
                    };

                    _pubNubService.PublishReportsToChannel($"{channelDetails.CompanyId}-{messageDto.ChannelId}", JsonConvert.SerializeObject(messageDto), loggedInContext);
                    _pubNubService.PublishPushNotificationToChannel(messageDto, new List<string>() { string.Format("{0}-{1}", channelDetails.CompanyId, messageDto.ChannelId) }, loggedInContext);

                    _messageRepository.MessagesInsert(new MessageUpsertInputModel
                    {
                        IsStarred = null,
                        SenderUserId = loggedInContext.LoggedInUserId,
                        ChannelId = channelId,
                        ChannelName = messageDto.ChannelName,
                        ReportMessage = webHookInputModel.ReportMessage,
                        MessageType = "Report",
                        Id = newMessageId
                    }, loggedInContext, new List<ValidationMessage>());
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendPublicMessageToChannel", "ChatService ", ex.Message), ex);

            }
            LoggingManager.Debug("Exited-SendPublicMessageToChannel");
        }

        public bool UpsertMessengerLog(MessengerAuditInputModel messengerAuditInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertMessengerLog", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return false;
            }

            bool result = _channelRepository.UpsertMessengerLog(messengerAuditInput, loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertMessengerLog", "ChatService"));

            return result;
        }

        public List<UserStatusTimesOutputModel> GetUserLastStatusTime(UserStatusTimesInputModel userStatusTimesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusFromTime", "ChatService"));

            List<UserStatusTimesOutputModel> userStatusTimesOutputModel = new List<UserStatusTimesOutputModel>();

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStatusTimesOutputModel> statusTimes = _channelRepository.GetUserLastStatusTime(userStatusTimesInputModel, loggedInContext, validationMessages);

            if (statusTimes?.Count > 0)
            {
                userStatusTimesOutputModel = statusTimes;

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusFromTime", "ChatService"));
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusFromTime", "ChatService"));

            return userStatusTimesOutputModel;
        }

        public List<UserStatusHistoryOutputModel> GetUserStatusHistory(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStatusHistory", "ChatService"));

            List<UserStatusHistoryOutputModel> userStatusHistoryList = new List<UserStatusHistoryOutputModel>();

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStatusHistoryOutputModel> statusHistory = _channelRepository.GetUserStatusHistory(userId, loggedInContext, validationMessages);

            if (statusHistory?.Count > 0)
            {
                userStatusHistoryList = statusHistory;

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStatusHistory", "ChatService"));
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStatusHistory", "ChatService"));

            return userStatusHistoryList;
        }

        public UnreadMessagesCountOutputModel GetUnreadMessagesCount(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUnreadMessagesCount", "ChatService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            UnreadMessagesCountOutputModel messagesCount = _channelRepository.GetUnreadMessagesCount(loggedInContext, validationMessages);

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnreadMessagesCount", "ChatService"));

            return messagesCount;
        }

        public bool UpdateMessageReadReceipt(MessageReadReceiptInputModel messageReadReceiptInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateMessageReadReceipt", "ChatService"));

            if (messageReadReceiptInputModel != null)
            {
                var result = _channelRepository.UpsertMessageReadReceipt(messageReadReceiptInputModel, loggedInContext, validationMessages);

                return result;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateMessageReadReceipt", "ChatService"));

            return false;
        }

        public void SendFeedback(HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string senderName)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendFeedback", "ChatService"));

            if (httpRequest.Files.Count > 0)
            {
                foreach (string file in httpRequest.Files)
                {
                    var postedFile = httpRequest.Files[file];

                    if (postedFile != null && string.IsNullOrEmpty(postedFile.FileName))
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileName)
                        });
                        return;
                    }

                    string filePath = _fileStoreService.PostFiles(postedFile);

                    BackgroundJob.Enqueue(() => SendLogFileToEmail(filePath, senderName, loggedInContext, new List<ValidationMessage>()));
                }
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendFeedback", "ChatService"));
        }

        public void SendLogFileToEmail(string filePath, string senderName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

            var html = _goalRepository.GetHtmlTemplateByName("MessengerFeedbackEmailTemplate", loggedInContext.CompanyGuid);

            var formattedHtml = html.Replace("##OperationPerformedUser##", senderName)
                                    .Replace("##siteAddress##", filePath);

            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = new[] { ConfigurationManager.AppSettings["ChatFeedbackLogRecieverMailId"] },
                HtmlContent = formattedHtml,
                Subject = "Snovasys office messenger feedback",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }

        public void BuildingDescription(List<UserStoryHistoryModel> userStoryHistoryList)
        {
            Parallel.ForEach(userStoryHistoryList, (userStoryHistory) =>
            {
                if (userStoryHistory.OldValue == null)
                {
                    userStoryHistory.OldValue = "null";
                }

                if (userStoryHistory.Description == "UserStoryAdded")
                {
                    userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.UserStoryName, userStoryHistory.FullName);
                }

                else if (userStoryHistory.Description == "UserStoryViewed")
                {
                    userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.FullName, userStoryHistory.UserStoryName, userStoryHistory.CreatedDateTime.ToString("dd-MMM-yyyy"));
                }

                else if (userStoryHistory.FieldName == "ParkedDateTime" || userStoryHistory.FieldName == "ArchivedDateTime")
                {
                    userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description));
                }

                else
                {
                    userStoryHistory.Description = string.Format(GetPropValue(userStoryHistory.Description), userStoryHistory.OldValue, userStoryHistory.NewValue);
                }
            });
        }

        public bool UpdateUnreadMessages(UnReadMessagesInputModel unReadMessagesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateMessageReadReceipt", "ChatService"));

            if (unReadMessagesInputModel != null)
            {
                var result = _channelRepository.UpdateUnreadMessages(unReadMessagesInputModel, loggedInContext, validationMessages);

                return result;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateMessageReadReceipt", "ChatService"));

            return false;
        }

        public List<MessageApiReturnModel> GetLatestMessages(LatestMessageSearchInputModel latestMessageSearchInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            List<MessageApiReturnModel> messagesList = new List<MessageApiReturnModel>();

            List<MessageSpReturnModel> chat = _messageRepository.GetLatestMessages(latestMessageSearchInputModel, loggedInContext, validationMessages);

            if (chat != null && chat.ToList().Count > 0)
            {
                List<MessageApiReturnModel> chatBetweenUsers = chat.Select(ConvertToMessageApiReturnModel).ToList();

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPersonalChat", "ChatService"));

                return chatBetweenUsers;
            }

            return messagesList;
        }

        private MessageApiReturnModel ConvertToMessageApiReturnModel(MessageSpReturnModel messageSpReturnModel)
        {
            MessageApiReturnModel messageApiReturnModel = new MessageApiReturnModel
            {

                Id = messageSpReturnModel.Id,
                ChannelId = messageSpReturnModel.ChannelId,
                ChannelName = messageSpReturnModel.ChannelName,
                SenderUserId = messageSpReturnModel.SenderUserId,
                ReceiverUserId = messageSpReturnModel.ReceiverUserId,
                MessageTypeId = messageSpReturnModel.MessageTypeId,
                TextMessage = messageSpReturnModel.TextMessage,
                ParentMessageId = messageSpReturnModel.ParentMessageId,
                ThreadCount = messageSpReturnModel.ThreadCount,
                MessageTimeSpan = messageSpReturnModel.MessageTimeSpan,
                IsDeleted = messageSpReturnModel.IsDeleted,
                MessageDateTime = messageSpReturnModel.MessageDateTime,
                UpdatedDateTime = messageSpReturnModel.UpdatedDateTime,
                LastReplyDateTime = messageSpReturnModel.LastReplyDateTime,
                FilePath = messageSpReturnModel.FilePath,
                FileType = messageSpReturnModel.FileType,
                ReceiverName = messageSpReturnModel.ReceiverName,
                ReceiverProfileImage = messageSpReturnModel.ReceiverProfileImage,
                SenderName = messageSpReturnModel.SenderName,
                SenderProfileImage = messageSpReturnModel.SenderProfileImage,
                UnreadMessageCount = messageSpReturnModel.UnreadMessageCount,
                TimeStamp = messageSpReturnModel.TimeStamp,
                IsEdited = messageSpReturnModel.IsEdited,
                IsRead = messageSpReturnModel.IsRead,
                IsActivityMessage = messageSpReturnModel.IsActivityMessage,
                IsPinned = messageSpReturnModel.IsPinned,
                IsStarred = messageSpReturnModel.IsStarred,
                PinnedByUserId = messageSpReturnModel.PinnedByUserId,
                ReportMessage = messageSpReturnModel.ReportMessage,
                TaggedMembersIds = messageSpReturnModel.TaggedMembersIds,
                TaggedMembersIdsXml = messageSpReturnModel.TaggedMembersIdsXml
            };

            messageApiReturnModel.TextMessage = Decrypt(messageSpReturnModel?.TextMessage);

            if (!string.IsNullOrEmpty(messageSpReturnModel.MessageReactionModel))
            {
                List<MessageReactionModel> messageReactios;

                try
                {
                    messageReactios = Utilities.GetObjectFromXml<MessageReactionModel>(messageSpReturnModel.MessageReactionModel, "MessageReactionModel");

                    Parallel.ForEach(messageReactios, (emojiDetails) =>
                    {

                        emojiDetails.ReactedDateTime = messageReactios.FirstOrDefault(x =>
                            x.ParentMessageId == emojiDetails.ParentMessageId &&
                            x.TextMessage == emojiDetails.TextMessage)?.ReactedDateTime;

                        Parallel.ForEach(messageReactios.Where(x => x.ParentMessageId == emojiDetails.ParentMessageId && x.TextMessage == emojiDetails.TextMessage).ToList(), (reactedByUserDEtails) =>
                        {
                            emojiDetails.ReactedByUserIds.Add(reactedByUserDEtails.ReactedByUserId);
                        });

                        emojiDetails.EmojiCount = emojiDetails.ReactedByUserIds?.Count ?? 0;

                    });

                    messageApiReturnModel.OverAllReactions = messageReactios;

                    messageReactios = messageReactios.GroupBy(x => x.TextMessage).Select(x => x.FirstOrDefault()).ToList();

                    messageApiReturnModel.MessageReactions = messageReactios?.Select(ConvertToReactionMessageApiReturnModel).OrderBy(x => x.ReactedDateTime).ToList();
                    if (!string.IsNullOrEmpty(messageSpReturnModel.TaggedMembersIdsXml))
                        messageApiReturnModel.TaggedMembersIds = Utilities.GetObjectFromXml<Guid?>(messageSpReturnModel.TaggedMembersIdsXml, "ArrayOfGuid");
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertToMessageApiReturnModel", "ChatService ", exception.Message), exception);

                }
            }

            return messageApiReturnModel;
        }

        private MessageReactionModel ConvertToReactionMessageApiReturnModel(MessageReactionModel messageSpReturnModel)
        {
            MessageReactionModel messageApiReturnModel = new MessageReactionModel
            {
                Id = messageSpReturnModel.Id,
                ParentMessageId = messageSpReturnModel.ParentMessageId,
                OriginalId = messageSpReturnModel.OriginalId,
                ReactedByUserId = messageSpReturnModel.ReactedByUserId,
                EmojiCount = messageSpReturnModel.EmojiCount,
                ReactedDateTime = messageSpReturnModel.ReactedDateTime
            };

            var textMessage = Decrypt(messageSpReturnModel.TextMessage);
            messageApiReturnModel.TextMessage = textMessage;


            messageApiReturnModel.ReactedByUserIds = messageSpReturnModel.ReactedByUserIds;
            return messageApiReturnModel;
        }

        private string GetPropValue(string propName)
        {
            object src = new LangText();
            return src.GetType().GetProperty(propName)?.GetValue(src, null).ToString();
        }

        public byte[] ReadFully(Stream input)
        {
            byte[] buffer = new byte[16 * 1024];

            using (MemoryStream ms = new MemoryStream())
            {
                int read;

                while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
                {
                    ms.Write(buffer, 0, read);
                }

                return ms.ToArray();
            }
        }

        public PubnubKeysApiReturnModel GetPubnubKeysFromSettings(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel
            {
                SearchText = "pubnub",
                IsArchived = false
            };

            PubnubKeysApiReturnModel result = new PubnubKeysApiReturnModel();

            var companySettings = _masterManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages);

            if (companySettings != null)
            {
                result.PublishKey = companySettings.Where(x => x.Key == "PubnubPublishKey").Select(x => x.Value).FirstOrDefault();
                result.SubscribeKey = companySettings.Where(x => x.Key == "PubnubSubscribeKey").Select(x => x.Value).FirstOrDefault();
            }

            return result;

        }

        public bool UpdateIsReadOnlyForChannelMembers(ChannelUpsertInputModel channelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateIsReadOnlyForChannelMembers", "ChatService"));

            if (channelModel.ChannelMemberModel != null && channelModel.ChannelMemberModel.Count > 0)
            {
                if (!ChatValidations.ValidateAddEmployeesToChannel(channelModel, loggedInContext, validationMessages))
                {
                    return false;
                }

                string channelMembersListXml = Utilities.ConvertIntoListXml(channelModel.ChannelMemberModel);

                channelModel.ChannelMemberXml = channelMembersListXml;

                var response = _channelMemberRepository.UpdateIsReadOnlyForChannelMembers(channelModel, loggedInContext, validationMessages);

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {
                        foreach (var channelmembers in channelModel.ChannelMemberModel)
                        {
                            var messageDtoValues = new MessageDto()
                            {
                                IsFromRemoveMember = false,
                                IsChannelMember = false,
                                IsFromAddMember = false,
                                ChannelId = channelModel.ChannelId,
                                SenderUserId = loggedInContext.LoggedInUserId,
                                FromUserId = loggedInContext.LoggedInUserId,
                                IsReadOnly = channelmembers.IsReadOnly,
                                IsFromReadOnly = true
                            };

                            _pubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(messageDtoValues), new List<string>() { string.Format("{0}-{1}", loggedInContext.CompanyGuid, channelModel.ChannelId) }, loggedInContext);
                        }
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateIsReadOnlyForChannelMembers", "ChatService ", exception.Message), exception);

                    }
                });

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateIsReadOnlyForChannelMembers", "ChatService"));

                return response;
            }

            return false;
        }


        public void GenerateAndInsertChannelActivityMessage(LoggedInContext loggedInContext, ChannelUpsertInputModel channelModel, bool? fromAddMembersToChannel, MessageUpsertInputModel messageUpsertInputModel = null)
        {
            try
            {
                string usersString = string.Empty;

                string activityMessageString = string.Empty;

                var channelMembers = channelModel.ChannelMemberModel?.Where(x => x.MemberUserId != loggedInContext.LoggedInUserId).ToList();

                if (channelMembers.Count > 0)
                {
                    var userDetails = _userRepository.GetSingleUserDetails((Guid)channelMembers?.FirstOrDefault()?.MemberUserId);

                    if (channelMembers.Count > 1)
                    {
                        usersString = userDetails.FullName + $" along with {channelMembers.Count - 1} others.";
                    }
                    else
                    {
                        usersString = userDetails.FullName;
                    }

                    activityMessageString = fromAddMembersToChannel == null ? $"Created {channelModel.ChannelName} and added {usersString}"
                                                                            : fromAddMembersToChannel == true ? $"Added {usersString}" : $"Removed {usersString}";
                }
                else if (Convert.ToBoolean(channelModel.ChannelMemberModel.Any(x => x.MemberUserId == loggedInContext.LoggedInUserId)) && channelModel.IsDeleted == true && fromAddMembersToChannel != null && fromAddMembersToChannel == false)
                {
                    var userDetails = _userRepository.GetSingleUserDetails((Guid)channelModel.ChannelMemberModel?.FirstOrDefault()?.MemberUserId);

                    activityMessageString = $"{userDetails?.FullName} left";
                }
                else
                {
                    activityMessageString = $"Created {channelModel.ChannelName}";
                }

                var messageModel = GetActivityMessageModel(activityMessageString, channelModel);

                var loggedInUserDetails = _userRepository.GetSingleUserDetails(loggedInContext.LoggedInUserId);

                if (messageModel != null)
                {
                    messageModel.SenderUserId = loggedInContext.LoggedInUserId;
                    messageModel.FromUserId = loggedInContext.LoggedInUserId;
                    messageModel.SenderName = loggedInUserDetails.FullName;
                    messageModel.SenderProfileImage = loggedInUserDetails.ProfileImage;
                    messageModel.body = messageModel.TextMessage;
                    messageModel.title = $"New message from {messageModel.SenderName}";
                    if (messageModel.ChannelId != null)
                        messageModel.title += $" in {messageModel.ChannelName}";
                    if (messageUpsertInputModel != null && messageUpsertInputModel.Id != Guid.Empty && messageUpsertInputModel.Id != null)
                    {
                        messageModel.Id = messageUpsertInputModel.Id;
                    }

                    PublishAndInsertActivityMessage(messageModel, loggedInContext);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateAndInsertChannelActivityMessage", "ChatService ", exception.Message), exception);

            }
        }

        public void PublishAndInsertActivityMessage(MessageDto messageModel, LoggedInContext loggedInContext)
        {
            try
            {
                var serializesdData = JsonConvert.SerializeObject(messageModel);

                _pubNubService.PublishMessageToChannel(serializesdData, new List<string>() { string.Format("{0}-{1}", loggedInContext.CompanyGuid, messageModel.ChannelId) }, loggedInContext);

                _pubNubService.PublishPushNotificationToChannel(messageModel, new List<string>() { string.Format("{0}-{1}", loggedInContext.CompanyGuid, messageModel.ChannelId) }, loggedInContext);

                var messageUpsertInputModel = new MessageUpsertInputModel
                {
                    Id = messageModel.Id,
                    ChannelId = messageModel.ChannelId,
                    SenderUserId = messageModel.SenderUserId,
                    IsStarred = null,
                    MessageType = messageModel.MessageType,
                    IsFromBackend = messageModel.IsFromBackend,
                    IsActivityMessage = messageModel.IsActivityMessage
                };

                string textMessage = Encrypt(messageModel.TextMessage);
                messageUpsertInputModel.TextMessage = textMessage;

                _messageRepository.MessagesInsert(messageUpsertInputModel, loggedInContext, new List<ValidationMessage>());
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishAndInsertActivityMessage", "ChatService ", exception.Message), exception);

            }
        }

        public MessageDto GetActivityMessageModel(string activityMessageString, ChannelUpsertInputModel channelModel)
        {
            try
            {
                return new MessageDto
                {
                    Id = Guid.NewGuid(),
                    TextMessage = activityMessageString,
                    MessageType = AppConstants.MessageType,
                    IsDeleted = false,
                    IsEdited = false,
                    ChannelId = channelModel.ChannelId,
                    ChannelName = channelModel.ChannelName,
                    MessageDateTime = DateTime.UtcNow,
                    IsActivityMessage = true,
                    IsFromBackend = true
                };
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityMessageModel", "ChatService ", exception.Message), exception);

                return null;
            }
        }
    }
}