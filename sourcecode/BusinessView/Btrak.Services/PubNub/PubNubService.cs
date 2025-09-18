using PubnubApi;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using BTrak.Common;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Chat;
using Btrak.Models.MasterData;
using Btrak.Services.Notification;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Btrak.Services.PubNub
{
    public class PubNubService : IPubNubService
    {
        private readonly ChannelRepository _chatRepository;
        private readonly MasterDataManagementRepository _masterManagementRepository;


        public PubNubService(ChannelRepository chatRepository, MasterDataManagementRepository masterDataManagementRepository)
        {
            _chatRepository = chatRepository;
            _masterManagementRepository = masterDataManagementRepository;
        }
        private Pubnub GetPubnubService(LoggedInContext loggedInContext)
        {
            PNConfiguration pubnubConfiguration = new PNConfiguration
            {
                PublishKey = ConfigurationManager.AppSettings["PubnubPublishKey"],
                SubscribeKey = ConfigurationManager.AppSettings["PubnubSubscribeKey"],
                ReconnectionPolicy = PNReconnectionPolicy.LINEAR
            };

            if (loggedInContext != null && loggedInContext.LoggedInUserId != null)
            {
                pubnubConfiguration.Uuid = loggedInContext.LoggedInUserId.ToString();
            }

            return new Pubnub(pubnubConfiguration);
        }

        public void PublishMessageToChannel(string messageJson, List<string> channelNames, LoggedInContext loggedInContext)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                foreach (var channel in channelNames)
                {
                    var messageDto = JsonConvert.DeserializeObject<MessageDto>(messageJson);

                    pubnub.Publish()
                       .Channel(channel)
                       .Message(JsonConvert.SerializeObject(messageDto, new JsonSerializerSettings { ContractResolver = new CamelCasePropertyNamesContractResolver() }))
                       .Execute(new PNPublishResultExt((publishResult, publishStatus) =>
                       {
                           if (publishStatus.Error)
                           {
                               LoggingManager.Debug("Error occured from pubnub" +
                                                    publishStatus.ErrorData?.Information);
                           }
                       }));
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishMessageToChannel", "PubNubService ", exception.Message), exception);

            }
            finally
            {
                pubnub.Destroy();
            }
        }

        public void PublishUserUpdatesToChannel(string message, List<string> pubnubChannels, LoggedInContext loggedInContext)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                foreach (var channelName in pubnubChannels)
                {

                    var messageDto = JsonConvert.DeserializeObject<MessageDto>(message);

                    pubnub.Publish()
                        .Channel(channelName)
                        .Message(JsonConvert.SerializeObject(messageDto, new JsonSerializerSettings { ContractResolver = new CamelCasePropertyNamesContractResolver() }))
                        .Execute(new PNPublishResultExt((publishResult, publishStatus) =>
                        {
                            if (publishStatus.Error)
                            {
                                LoggingManager.Debug("Error occured from pubnub" +
                                                     publishStatus.ErrorData?.Information);
                            }
                        }));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishUserUpdatesToChannel", "PubNubService ", ex.Message), ex);

            }
            finally
            {
                pubnub.Destroy();
            }
        }

        public void PublishReportsToChannel(string channelName, string message, LoggedInContext loggedInContext)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                var messageDto = JsonConvert.DeserializeObject<MessageDto>(message);

                pubnub.Publish()
                    .Channel(channelName)
                    .Message(JsonConvert.SerializeObject(messageDto, new JsonSerializerSettings { ContractResolver = new CamelCasePropertyNamesContractResolver() }))
                    .Execute(new PNPublishResultExt((publishResult, publishStatus) =>
                    {
                        if (publishStatus.Error)
                        {
                            LoggingManager.Debug("Error occured from pubnub" + publishStatus.ErrorData?.Information);
                        }
                    }));
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishReportsToChannel", "PubNubService ", ex.Message), ex);

            }
            finally
            {
                pubnub.Destroy();
            }
        }

        public void PublishPushNotificationToChannel(MessageDto messageDto, List<string> channelNames, LoggedInContext loggedInContext)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                MobilePayload payload = new MobilePayload
                {
                    pn_gcm = new Pn_gcm
                    {
                        notification = new MessageDto
                        {
                            title = messageDto.title,
                            body = messageDto.body,
                            Id = messageDto.Id
                        }
                    }
                };

                payload.pn_gcm.data = new Dictionary<string, string>
                {
                    { "messageJson", JsonConvert.SerializeObject(messageDto) }
                };

                foreach (var channel in channelNames)
                {
                    pubnub.Publish()
                          .Message(payload)
                          .Channel(channel)
                          .Execute(new PNPublishResultExt((publishResult, publishStatus) =>
                          {
                              LoggingManager.Debug("pub timetoken: " + publishResult?.Timetoken.ToString());
                              LoggingManager.Debug("pub status code : " + publishStatus.StatusCode.ToString());
                              LoggingManager.Debug("pubnub error code: " + publishStatus.Error.ToString());
                              LoggingManager.Debug("pubnub error data: " + publishStatus.ErrorData?.Information.ToString());
                          }));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishPushNotificationToChannel", "PubNubService ", ex.Message), ex);

            }
            finally
            {
                pubnub.Destroy();
            }
        }

        public void PublishStartStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10)
        {
            try
            {
                var pubnub = GetPubnubService(loggedInContext);

                pubnub.GetPresenceState()
                    .Channels(new[] { string.Format(AppConstants.DefaultPresenceChannelName, loggedInContext.CompanyGuid) })
                    .Uuid(loggedInContext.LoggedInUserId.ToString())
                    .Execute(new PNGetStateResultExt((result, status) =>
                    {
                        if (!status.Error)
                        {
                            var states = result.StateByUUID ?? new Dictionary<string, object>();

                            if (states.ContainsKey(AppConstants.FinishStatusName))
                            {
                                states[AppConstants.FinishStatusName] = false;
                            }
                            else
                            {
                                states.Add(AppConstants.FinishStatusName, false);
                            }

                            PublishStatesOfUser(loggedInContext, states, hostAddress);
                        }
                        else if (retryCount <= 1)
                        {
                            LoggingManager.Error("Unable to Publish Start Status of user with the state - " + JsonConvert.SerializeObject(status.ErrorData, Formatting.Indented));
                        }
                        else
                        {
                            PublishStartStatusOfUser(loggedInContext, hostAddress, retryCount - 1);
                        }
                    }));
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishStartStatusOfUser", "PubNubService ", exception.Message), exception);

            }
        }

        public void PublishLunchStartStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                pubnub.GetPresenceState()
                    .Channels(new[] { string.Format(AppConstants.DefaultPresenceChannelName, loggedInContext.CompanyGuid) })
                    .Uuid(loggedInContext.LoggedInUserId.ToString())
                    .Execute(new PNGetStateResultExt((result, status) =>
                    {
                        if (!status.Error)
                        {
                            var states = result.StateByUUID ?? new Dictionary<string, object>();

                            if (states.ContainsKey(AppConstants.ActiveStatusName))
                            {
                                states[AppConstants.ActiveStatusName] = false;
                            }

                            if (states.ContainsKey(AppConstants.LunchStatusName))
                            {
                                states[AppConstants.LunchStatusName] = true;
                            }
                            else
                            {
                                states.Add(AppConstants.LunchStatusName, true);
                            }

                            PublishStatesOfUser(loggedInContext, states, hostAddress, AppConstants.Lunch);
                        }
                        else if (retryCount <= 1)
                        {
                            LoggingManager.Error("Unable to Publish Lunch Start Status of user with the state - " + JsonConvert.SerializeObject(status.ErrorData, Formatting.Indented));
                        }
                        else
                        {
                            PublishLunchStartStatusOfUser(loggedInContext, hostAddress, retryCount - 1);
                        }
                    }));
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishLunchStartStatusOfUser", "PubNubService ", exception.Message), exception);

            }
            finally
            {
                pubnub?.Destroy();
            }
        }

        public void PublishLunchEndStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                pubnub.GetPresenceState()
                    .Channels(new[] { string.Format(AppConstants.DefaultPresenceChannelName, loggedInContext.CompanyGuid) })
                    .Uuid(loggedInContext.LoggedInUserId.ToString())
                    .Execute(new PNGetStateResultExt((result, status) =>
                    {
                        if (!status.Error)
                        {
                            var states = result.StateByUUID ?? new Dictionary<string, object>();

                            if (states.ContainsKey(AppConstants.ActiveStatusName))
                            {
                                states[AppConstants.ActiveStatusName] = true;
                            }

                            if (states.ContainsKey(AppConstants.LunchStatusName))
                            {
                                states[AppConstants.LunchStatusName] = false;
                            }
                            else
                            {
                                states.Add(AppConstants.LunchStatusName, false);
                            }

                            PublishStatesOfUser(loggedInContext, states, hostAddress, AppConstants.Active);
                        }
                        else if (retryCount <= 1)
                        {
                            LoggingManager.Error("Unable to Publish Lunch End Status of user with the state - " + JsonConvert.SerializeObject(status.ErrorData, Formatting.Indented));
                        }
                        else
                        {
                            PublishLunchEndStatusOfUser(loggedInContext, hostAddress, retryCount - 1);
                        }
                    }));
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishLunchEndStatusOfUser", "PubNubService ", exception.Message), exception);

            }
            finally
            {
                pubnub?.Destroy();
            }
        }

        public void PublishBreakStartStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                pubnub.GetPresenceState()
                    .Channels(new[] { string.Format(AppConstants.DefaultPresenceChannelName, loggedInContext.CompanyGuid) })
                    .Uuid(loggedInContext.LoggedInUserId.ToString())
                    .Execute(new PNGetStateResultExt((result, status) =>
                    {
                        if (!status.Error)
                        {
                            var states = result.StateByUUID ?? new Dictionary<string, object>();

                            if (states.ContainsKey(AppConstants.ActiveStatusName))
                            {
                                states[AppConstants.ActiveStatusName] = false;
                            }

                            if (states.ContainsKey(AppConstants.BreakStatusName))
                            {
                                states[AppConstants.BreakStatusName] = true;
                            }
                            else
                            {
                                states.Add(AppConstants.BreakStatusName, true);
                            }

                            PublishStatesOfUser(loggedInContext, states, hostAddress, AppConstants.Break);
                        }
                        else if (retryCount <= 1)
                        {
                            LoggingManager.Error("Unable to Publish Break Start Status of user with the state - " + JsonConvert.SerializeObject(status.ErrorData, Formatting.Indented));
                        }
                        else
                        {
                            PublishBreakStartStatusOfUser(loggedInContext, hostAddress, retryCount - 1);
                        }
                    }));
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishBreakStartStatusOfUser", "PubNubService ", exception.Message), exception);

            }
            finally
            {
                pubnub?.Destroy();
            }
        }

        public void PublishBreakEndStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                pubnub.GetPresenceState()
                    .Channels(new[] { string.Format(AppConstants.DefaultPresenceChannelName, loggedInContext.CompanyGuid) })
                    .Uuid(loggedInContext.LoggedInUserId.ToString())
                    .Execute(new PNGetStateResultExt((result, status) =>
                    {
                        if (!status.Error)
                        {
                            var states = result.StateByUUID ?? new Dictionary<string, object>();

                            if (states.ContainsKey(AppConstants.ActiveStatusName))
                            {
                                states[AppConstants.ActiveStatusName] = true;
                            }

                            if (states.ContainsKey(AppConstants.BreakStatusName))
                            {
                                states[AppConstants.BreakStatusName] = false;
                            }
                            else
                            {
                                states.Add(AppConstants.BreakStatusName, false);
                            }

                            PublishStatesOfUser(loggedInContext, states, hostAddress, AppConstants.Active);
                        }
                        else if (retryCount <= 1)
                        {
                            LoggingManager.Error("Unable to Publish Break end Status of user with the state - " + JsonConvert.SerializeObject(status.ErrorData, Formatting.Indented));
                        }
                        else
                        {
                            PublishBreakEndStatusOfUser(loggedInContext, hostAddress, retryCount - 1);
                        }
                    }));
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishBreakEndStatusOfUser", "PubNubService ", exception.Message), exception);

            }
            finally
            {
                pubnub?.Destroy();
            }
        }

        public void PublishFinishStatusOfUser(LoggedInContext loggedInContext, string hostAddress, int retryCount = 10)
        {
            var pubnub = GetPubnubService(loggedInContext);

            try
            {
                pubnub.GetPresenceState()
                    .Channels(new[] { string.Format(AppConstants.DefaultPresenceChannelName, loggedInContext.CompanyGuid) })
                    .Uuid(loggedInContext.LoggedInUserId.ToString())
                    .Execute(new PNGetStateResultExt((result, status) =>
                    {
                        if (!status.Error)
                        {
                            var states = result.StateByUUID ?? new Dictionary<string, object>();

                            if (states.ContainsKey(AppConstants.ActiveStatusName))
                            {
                                states[AppConstants.ActiveStatusName] = false;
                            }

                            if (states.ContainsKey(AppConstants.FinishStatusName))
                            {
                                states[AppConstants.FinishStatusName] = true;
                            }
                            else
                            {
                                states.Add(AppConstants.FinishStatusName, true);
                            }

                            PublishStatesOfUser(loggedInContext, states, hostAddress, AppConstants.Finish);
                        }
                        else if (retryCount <= 1)
                        {
                            LoggingManager.Error("Unable to Publish finish Status of user with the state - " + JsonConvert.SerializeObject(status.ErrorData, Formatting.Indented));
                        }
                        else
                        {
                            PublishFinishStatusOfUser(loggedInContext, hostAddress, retryCount - 1);
                        }
                    }));
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishFinishStatusOfUser", "PubNubService ", exception.Message), exception);

            }
            finally
            {
                pubnub?.Destroy();
            }
        }

        private void PublishStatesOfUser(LoggedInContext loggedInContext, Dictionary<string, object> states, string hostAddress, Guid? statusId = null, int retryCount = 10)
        {
            try
            {
                if (retryCount <= 0)
                {
                    LoggingManager.Info("Unable to Publish status of current user"); //TODO : Webhook/channel/pubnub issues
                }

                var pubnub = GetPubnubService(loggedInContext);

                pubnub.PNConfig.Uuid = loggedInContext.LoggedInUserId.ToString();

                if (states != null && states.Count > 0)
                {
                    pubnub.SetPresenceState()
                        .Channels(new[] { string.Format(AppConstants.DefaultPresenceChannelName, loggedInContext.CompanyGuid) })
                        .State(states)
                        .Execute(new PNSetStateResultExt((result, status) =>
                        {
                            if (status.Error)
                            {
                                PublishStatesOfUser(loggedInContext, states, hostAddress, statusId, retryCount - 1);
                            }
                            else
                            {
                                if (statusId != null)
                                {
                                    _chatRepository.UpsertMessengerLog(new MessengerAuditInputModel
                                    {
                                        IpAddress = hostAddress,
                                        PlatformId = AppConstants.Windows,
                                        StatusId = statusId,
                                        UserId = loggedInContext.LoggedInUserId
                                    }, loggedInContext, new List<ValidationMessage>());
                                }
                            }
                        }));
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PublishStatesOfUser", "PubNubService ", exception.Message), exception);

            }
        }
    }
}