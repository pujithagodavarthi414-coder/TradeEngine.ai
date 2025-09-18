using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Chat;
using Btrak.Services.Chat;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Chat
{
    public class ChatApiController : AuthTokenApiController
    {
        private readonly IChatService _chatService;


        public ChatApiController(IChatService chatService)
        {
            _chatService = chatService;
        }

        #region SendMessageToUserOrChannel
        [HttpPost]
        [HttpOptions]
        [ActionName("SendMessagesToUserOrChannel")]
        [Route(RouteConstants.SendMessagesToUserOrChannel)]
        public JsonResult<BtrakSlackJsonResult> SendMessagesToUserOrChannel(MessageUpsertInputModel individualMessageModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendMessagesToUserOrChannel", "Chat Api"));

            try
            {
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                UpsertMessageOutputModel messages = _chatService.SendMessageToChannelOrUser(individualMessageModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendMessagesToUserOrChannel", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendMessagesToUserOrChannel", "Chat Api"));

                return Json(new BtrakSlackJsonResult { Success = true, Data = messages }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMessagesToUserOrChannel", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region GetPersonalChatOrChannelChat
        [HttpPost]
        [HttpOptions]
        [ActionName("GetPersonalChatOrChannelChat")]
        [Route(RouteConstants.GetPersonalChatOrChannel)]
        public JsonResult<BtrakSlackJsonResult> GetPersonalChatOrChannelChat(MessageSearchInputModel messageSearchInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPersonalChatOrChannelChat", "Chat Api"));

            try
            {
                var validationMessages = new List<ValidationMessage>();

                bool isLatestVersion = false;
                string versionName = string.Empty;

                BtrakJsonResult btrakJsonResult;

                var chat = !messageSearchInputModel.IsForSingleMessageDetails
                    ? !messageSearchInputModel.IsPersonalChat
                        ? _chatService.GetChannelChat(messageSearchInputModel, LoggedInContext, validationMessages)
                        : _chatService.GetPersonalChat(messageSearchInputModel, LoggedInContext, validationMessages)
                    : _chatService.GetPersonalChat(messageSearchInputModel, LoggedInContext, validationMessages);

                if (!string.IsNullOrEmpty(messageSearchInputModel.MobileVersionNumber))
                {
                    isLatestVersion = messageSearchInputModel.MobileVersionNumber.Equals(ConfigurationManager.AppSettings["MobileAppVersion"]);
                    versionName = ConfigurationManager.AppSettings["MobileAppVersion"];
                }

                if (!string.IsNullOrEmpty(messageSearchInputModel.WindowsVersionNumber))
                {
                    isLatestVersion = messageSearchInputModel.WindowsVersionNumber.Equals(ConfigurationManager.AppSettings["WindowsAppVersion"]);
                    versionName = ConfigurationManager.AppSettings["WindowsAppVersion"];
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPersonalChatOrChannelChat", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { VersionNumber = versionName, IsLatestVersion = isLatestVersion, Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPersonalChatOrChannelChat", "Chat Api"));

                return Json(new BtrakSlackJsonResult { VersionNumber = versionName, IsLatestVersion = isLatestVersion, Data = chat }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPersonalChatOrChannelChat", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion        

        #region CreateNewChannel
        [HttpPost]
        [ActionName("CreateNewChannel")]
        [Route(RouteConstants.CreateNewChannel)]
        public JsonResult<BtrakSlackJsonResult> CreateNewChannel(ChannelUpsertInputModel channelModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateNewChannel", "Chat Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? channelId = _chatService.CreateNewChannel(channelModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateNewChannel", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateNewChannel", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = channelId }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateNewChannel", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region UpdateChannel
        [HttpPost]
        [ActionName("UpdateChannel")]
        [Route(RouteConstants.UpdateChannel)]
        public JsonResult<BtrakSlackJsonResult> UpdateChannel(ChannelUpsertInputModel channelModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateChannel", "Channel Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? channel = _chatService.UpdateChannel(channelModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateChannel", "Channel Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateChannel", "Channel Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = channel }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateChannel", "ChatApiController", exception.Message), exception);

                throw;
            }
        }
        #endregion

        #region GetUserChannels
        [HttpPost]
        [HttpOptions]
        [ActionName("GetUserChannels")]
        [Route(RouteConstants.GetUserChannels)]
        public JsonResult<BtrakSlackJsonResult> GetUserChannels(ChannelSearchInputModel channelSearchInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserChannels", "Chat Api"));

            try
            {
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (channelSearchInputModel == null)
                {
                    channelSearchInputModel = new ChannelSearchInputModel();
                }

                IList<ChannelApiReturnModel> userChannels = _chatService.GetUserChannels(channelSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserChannels", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserChannels", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Data = userChannels }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserChannels", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region ArchiveChannel
        [HttpGet]
        [ActionName("ArchiveChannel")]
        [Route(RouteConstants.ArchiveChannel)]
        public JsonResult<BtrakSlackJsonResult> ArchiveChannel(Guid channelId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveChannel", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                bool isArchived = _chatService.ArchiveChannel(channelId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveChannel", "Channel Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveChannel", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = isArchived }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveChannel", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region AddUsersToChannel
        [HttpPost]
        [HttpOptions]
        [ActionName("AddEmployeesToChannel")]
        [Route(RouteConstants.AddEmployeesToChannel)]
        public JsonResult<BtrakSlackJsonResult> AddEmployeesToChannel(ChannelUpsertInputModel channelModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddEmployeesToChannel", "Chat Api"));

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddEmployeesToChannel", "Chat Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? channelId = _chatService.AddEmployeesToChannel(channelModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddEmployeesToChannel", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddEmployeesToChannel", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = channelId }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddEmployeesToChannel", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region GetChannelMembers
        [HttpPost]
        [HttpOptions]
        [ActionName("GetChannelMembers")]
        [Route(RouteConstants.GetChannelMembers)]
        public JsonResult<BtrakSlackJsonResult> GetChannelMembers(ChannelMemberSearchInputModel channelMemberSearchInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetChannelMembers", "Chat Api"));

            try
            {
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (channelMemberSearchInputModel == null)
                {
                    channelMemberSearchInputModel = new ChannelMemberSearchInputModel();
                }

                IList<ChannelMemberApiReturnModel> channelMembers = _chatService.GetChannelMembers(channelMemberSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetChannelMembers", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetChannelMembers", "Chat Api"));

                return Json(new BtrakSlackJsonResult { Data = channelMembers }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetChannelMembers", "ChatApiController", exception.Message), exception);


                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        [HttpGet]
        [ActionName("GetLatestPunchCardStatusOfAnUser")]
        [Route(RouteConstants.GetLatestPunchCardStatusOfAnUser)]
        public JsonResult<BtrakSlackJsonResult> GetLatestPunchCardStatusOfAnUser()
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLatestPunchCardStatusOfAnUser", "Chat Api"));

            try
            {
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<LatestPunchCardStatusOfAnUserApiReturnModel> UsersList = _chatService.GetLatestPunchCardStatusOfAnUser(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLatestPunchCardStatusOfAnUser", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLatestPunchCardStatusOfAnUser", "Chat Api"));

                return Json(new BtrakSlackJsonResult { Data = UsersList }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLatestPunchCardStatusOfAnUser", "ChatApiController", exception.Message), exception);
                            return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [ActionName("GetRecentConversations")]
        [Route(RouteConstants.GetRecentConversations)]
        public JsonResult<BtrakSlackJsonResult> GetRecentConversations()
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRecentConversations", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<RecentConversationsSpReturnModel> Conversations = _chatService.GetRecentConversations(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentConversations", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentConversations", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = Conversations }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetRecentChannelMessages, exception);
                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [ActionName("GetSharedorUnsharedchannels")]
        [Route(RouteConstants.GetSharedorUnsharedchannels)]
        public JsonResult<BtrakSlackJsonResult> GetSharedorUnsharedchannels(SearchSharedorUnsharedchannelsInputModel searchSharedorUnsharedchannelsInputModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSharedorUnsharedchannels", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SearchSharedorUnsharedchannelsOutputModel> channels = _chatService.GetSharedorUnsharedchannels(searchSharedorUnsharedchannelsInputModel,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSharedorUnsharedchannels", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSharedorUnsharedchannels", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = channels }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetRecentChannelMessages, exception);
                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #region ArchiveChannelMembers    
        [HttpPost]
        [HttpOptions]
        [ActionName("ArchiveChannelMembers")]
        [Route(RouteConstants.ArchiveChannelMembers)]
        public JsonResult<BtrakSlackJsonResult> ArchiveChannelMembers(ChannelUpsertInputModel channelModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveChannelMembers", "Chat Api"));

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveChannelMembers", "Chat Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? channelId = _chatService.ArchiveChannelMembers(channelModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveChannelMembers", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveChannelMembers", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = channelId }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveChannelMembers", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region AddOrUpdateUserFcmToken    
        [HttpGet]
        [ActionName("AddOrUpdateUserFcmToken")]
        [Route(RouteConstants.AddOrUpdateUserFcmToken)]
        public void AddOrUpdateUserFcmToken(string userId, string userUniqueId, string fcmToken, bool isRemove, bool isFromBTrakMobile = false)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddOrUpdateUserFcmToken", "Chat Api"));

            try
            {
                if (ModelState.IsValid)
                {
                    _chatService.AddOrUpdateUserFcmDetails(userId, userUniqueId, fcmToken, isRemove, isFromBTrakMobile, LoggedInContext);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddOrUpdateUserFcmToken", "ChatApiController", exception.Message), exception);

            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddOrUpdateUserFcmToken", "Chat Api"));
        }
        #endregion        

        #region UpsertChannel
        [HttpPost]
        [HttpOptions]
        [ActionName("UpsertChannel")]
        [Route(RouteConstants.UpsertChannel)]
        public JsonResult<BtrakSlackJsonResult> UpsertChannel(ChannelUpsertInputModel channelModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateNewChannel", "Chat Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? channel = _chatService.UpsertChannel(channelModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateNewChannel", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateNewChannel", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = channel }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertChannel", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region GetRecentIndividualMessages

        [HttpGet]
        [HttpOptions]
        [ActionName("GetRecentIndividualMessages")]
        [Route(RouteConstants.GetRecentIndividualMessages)]
        public JsonResult<BtrakSlackJsonResult> GetRecentIndividualMessages()
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRecentIndividualMessages", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<RecentIndividualConversationSpReturnModel> messagesList = _chatService.GetRecentIndividualMessages(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentIndividualMessages", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentIndividualMessages", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = messagesList }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRecentIndividualMessages", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region GetRecentChannelMessages

        [HttpGet]
        [HttpOptions]
        [ActionName("GetRecentChannelMessages")]
        [Route(RouteConstants.GetRecentChannelMessages)]
        public JsonResult<BtrakSlackJsonResult> GetRecentChannelMessages()
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRecentChannelMessages", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<RecentChannelConversationApiReturnModel> channelsList = _chatService.GetRecentChannelMessages(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentChannelMessages", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentChannelMessages", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = channelsList }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRecentChannelMessages", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region GetPinnedOrStaredMessages
        [HttpPost]
        [ActionName("GetPinnedOrStaredMessages")]
        [Route(RouteConstants.GetPinnedOrStaredMessages)]
        public JsonResult<BtrakSlackJsonResult> GetPinnedOrStaredMessages(MessageSearchInputModel messageSearchInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPersonalChatOrChannelChat", "Chat Api"));

            try
            {
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                IList<MessageApiReturnModel> chat =
                    _chatService.GetPinnedOrStaredMessages(messageSearchInputModel, LoggedInContext,
                        validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPinnedOrStaredMessages", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPinnedOrStaredMessages", "Chat Api"));

                return Json(new BtrakSlackJsonResult { Data = chat }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPinnedOrStaredMessages", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region ShareMessageToContacts

        [HttpPost]
        [ActionName("ShareMessageToContacts")]
        [Route(RouteConstants.ShareMessageToContacts)]
        public JsonResult<BtrakSlackJsonResult> ShareMessageToContacts(MessageShareModel messageShareModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ShareMessageToContacts", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                List<MessageShareSpReturnModel> messageShareResult = _chatService.ShareMessageToContacts(messageShareModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ShareMessageToContacts", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = true, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ShareMessageToContacts", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = messageShareResult }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ShareMessageToContacts", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region UpsertMuteOrStarContact

        [HttpPost]
        [ActionName("UpsertMuteOrStarContact")]
        [Route(RouteConstants.UpsertMuteOrStarContact)]
        public JsonResult<BtrakSlackJsonResult> UpsertMuteOrStarContact(MuteOrStarContactModel muteOrStarContactModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertMuteOrStarContact", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                bool muteOrStarContactResult = _chatService.UpsertMuteOrStarContact(muteOrStarContactModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertMuteOrStarContact", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = true, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertMuteOrStarContact", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = muteOrStarContactResult }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMuteOrStarContact", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region GetAllStarredMessages

        [HttpPost]
        [ActionName("GetAllStarredMessages")]
        [Route(RouteConstants.GetAllStarredMessages)]
        public JsonResult<BtrakSlackJsonResult> GetAllStarredMessages(MessageSearchInputModel messageSearchInputModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllStarredMessages", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<StarredMessagesApiReturnModel> starredMessagesList = _chatService.GetAllStarredMessages(messageSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllStarredMessages", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllStarredMessages", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = starredMessagesList }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllStarredMessages", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region GetSharedFiles

        [HttpPost]
        [ActionName("GetSharedFiles")]
        [Route(RouteConstants.GetSharedFiles)]
        public JsonResult<BtrakSlackJsonResult> GetSharedFiles(SharedFilesSearchInputModel sharedFilesSearchInputModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSharedFiles", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                var data = _chatService.GetSharedFiles(sharedFilesSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessages.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSharedFiles", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages },
                        UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSharedFiles", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = data }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSharedFiles", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message },
                    UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region ChannelWebHook
        [HttpPost]
        [AllowAnonymous]
        [Route(RouteConstants.ChannelWebHook)]
        public void SendBackgroudMessageToChannel(WebHookInputModel webHookInputModel)
        {
            try
            {
                LoggingManager.Info("Entered into SendBackgroudMessageToChannel");

                if(webHookInputModel != null)
                {
                    _chatService.SendPublicMessageToChannel(webHookInputModel);
                }

                LoggingManager.Info("Exit from SendBackgroudMessageToChannel");
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendBackgroudMessageToChannel", "ChatApiController", exception.Message), exception);
            }
        }
        #endregion

        #region UpsertMessengerLog

        [HttpPost]
        [ActionName("UpsertMessengerLog")]
        [Route(RouteConstants.UpsertMessengerLog)]
        public JsonResult<BtrakSlackJsonResult> UpsertMessengerLog(MessengerAuditInputModel messengerAuditInputModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertMessengerLog", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                messengerAuditInputModel.IpAddress = HttpContext.Current.Request.UserHostAddress;

                bool muteOrStarContactResult = _chatService.UpsertMessengerLog(messengerAuditInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertMessengerLog", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = true, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertMessengerLog", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = muteOrStarContactResult }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMessengerLog", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region GetStatusFromTimes

        [HttpPost]
        [ActionName("GetUserLastStatusTime")]
        [Route(RouteConstants.GetUserLastStatusTime)]
        public JsonResult<BtrakSlackJsonResult> GetUserLastStatusTime(UserStatusTimesInputModel userStatusTimesInputModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusFromTime", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserStatusTimesOutputModel> statusTimesOutput = _chatService.GetUserLastStatusTime(userStatusTimesInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusFromTime", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusFromTime", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = statusTimesOutput }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserLastStatusTime", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region GetPubnubKeys
        [HttpGet]
        [HttpOptions] 
        [ActionName("GetPubnubKeys")]
        [Route(RouteConstants.GetPubnubKeys)]
        public JsonResult<BtrakSlackJsonResult> GetPubnubKeys()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPubnubKeys", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                PubnubKeysApiReturnModel pubnubKeysApiReturnModel = new PubnubKeysApiReturnModel
                {
                    PublishKey = ConfigurationManager.AppSettings["PubnubPublishKey"],
                    SubscribeKey = ConfigurationManager.AppSettings["PubnubSubscribeKey"]
                };

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPubnubKeys", "Channel Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPubnubKeys", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true,Data = pubnubKeysApiReturnModel }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPubnubKeys", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region GetUserStatusHistory
        [HttpGet]
        [ActionName("GetUserStatusHistoryById")]
        [Route(RouteConstants.GetUserStatusHistoryById)]
        public JsonResult<BtrakSlackJsonResult> GetUserStatusHistoryById(Guid? userId)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStatusHistoryById", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserStatusHistoryOutputModel> userStatusHistoryOutputModel = _chatService.GetUserStatusHistory(userId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStatusHistoryById", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStatusHistoryById", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = userStatusHistoryOutputModel }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStatusHistoryById", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region SendFeedback
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendFeedback)]
        public JsonResult<BtrakJsonResult> SendFeedback(string senderName)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendFeedback", "Chat Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                var httpRequest = HttpContext.Current.Request;

                _chatService.SendFeedback(httpRequest, LoggedInContext, validationMessages, senderName);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendFeedback", "Chat Api"));

                return Json(new BtrakJsonResult { Data = true, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendFeedback", "ChatApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region GetTotalUnreadMessagesCount
        [HttpGet]
        [ActionName("GetUnreadMessagesCount")]
        [Route(RouteConstants.GetUnreadMessagesCount)]
        public JsonResult<BtrakSlackJsonResult> GetUnreadMessagesCount()
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUnreadMessagesCount", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                UnreadMessagesCountOutputModel unreadMessagesCountOutputModel = _chatService.GetUnreadMessagesCount(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnreadMessagesCount", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnreadMessagesCount", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = unreadMessagesCountOutputModel }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnreadMessagesCount", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region Update MessageReadReceipt

        [HttpPost]
        [ActionName("UpdateMessageReadReceipt")]
        [Route(RouteConstants.UpdateMessageReadReceipt)]
        public JsonResult<BtrakSlackJsonResult> UpdateMessageReadReceipt(MessageReadReceiptInputModel messageReadReceiptInputModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateMessageReadReceipt", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                bool muteOrStarContactResult = _chatService.UpdateMessageReadReceipt(messageReadReceiptInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateMessageReadReceipt", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = true, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateMessageReadReceipt", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = muteOrStarContactResult }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateMessageReadReceipt", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion

        #region Update UpdateUnreadMessages

        [HttpPost]
        [ActionName("UpdateUnreadMessages")]
        [Route(RouteConstants.UpdateUnreadMessages)]
        public JsonResult<BtrakSlackJsonResult> UpdateUnreadMessages(UnReadMessagesInputModel messageReadReceiptInputModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateUnreadMessages", "Chat Api"));

                var validationMessages = new List<ValidationMessage>();

                bool result = _chatService.UpdateUnreadMessages(messageReadReceiptInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateUnreadMessages", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = true, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateUnreadMessages", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUnreadMessages", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        #endregion


        #region GetLatestMessagesFromServer
        [HttpPost]
        [Route(RouteConstants.GetLatestMessagesFromServer)]
        public JsonResult<BtrakSlackJsonResult> GetLatestMessagesFromServer(LatestMessageSearchInputModel latestMessageSearchInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLatestMessagesFromServer", "Chat Api"));

            try
            {
                var validationMessages = new List<ValidationMessage>();

                bool isLatestVersion = false;
                string versionName = string.Empty;

                BtrakJsonResult btrakJsonResult;

                List<MessageApiReturnModel> messagesApiReturnModels =
                    _chatService.GetLatestMessages(latestMessageSearchInputModel, LoggedInContext, validationMessages);

                if (!string.IsNullOrEmpty(latestMessageSearchInputModel.MobileVersionNumber))
                {
                    isLatestVersion = latestMessageSearchInputModel.MobileVersionNumber.Equals(ConfigurationManager.AppSettings["MobileAppVersion"]);
                    versionName = ConfigurationManager.AppSettings["MobileAppVersion"];
                }

                if (!string.IsNullOrEmpty(latestMessageSearchInputModel.WindowsVersionNumber))
                {
                    isLatestVersion = latestMessageSearchInputModel.WindowsVersionNumber.Equals(ConfigurationManager.AppSettings["WindowsAppVersion"]);
                    versionName = ConfigurationManager.AppSettings["WindowsAppVersion"];
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLatestMessagesFromServer", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { VersionNumber = versionName, IsLatestVersion = isLatestVersion, Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLatestMessagesFromServer", "Chat Api"));

                return Json(new BtrakSlackJsonResult { VersionNumber = versionName, IsLatestVersion = isLatestVersion, Data = messagesApiReturnModels }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLatestMessagesFromServer", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region Update ReadOnly for channel Members
        [HttpPost]
        [ActionName("UpdateIsReadOnlyForChannelMembers")]
        [Route(RouteConstants.UpdateIsReadOnlyForChannelMembers)]
        public JsonResult<BtrakSlackJsonResult> UpdateIsReadOnlyForChannelMembers(ChannelUpsertInputModel channelModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateIsReadOnlyForChannelMembers", "Chat Api"));

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateIsReadOnlyForChannelMembers", "Chat Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                bool result = _chatService.UpdateIsReadOnlyForChannelMembers(channelModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateIsReadOnlyForChannelMembers", "Chat Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateIsReadOnlyForChannelMembers", "Chat Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateIsReadOnlyForChannelMembers", "ChatApiController", exception.Message), exception);

                return Json(new BtrakSlackJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion
    }
}