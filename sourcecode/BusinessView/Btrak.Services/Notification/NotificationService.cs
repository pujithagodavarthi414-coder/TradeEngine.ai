using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Web.Configuration;
using System.Web.Script.Serialization;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Chat;
using Btrak.Models.MasterData;
using Btrak.Models.Notification;
using Btrak.Models.Widgets;
using Btrak.Services.Helpers;
using BTrak.Common;
using BTrak.Common.Constants;
using Newtonsoft.Json;
using PubnubApi;
using Btrak.Models.FormDataServices;
using System.Text;

namespace Btrak.Services.Notification
{
    public class NotificationService : INotificationService
    {
        private readonly MessageRepository _messageRepository = new MessageRepository();
        private readonly NotificationRepository _notificationRepository = new NotificationRepository();
        private readonly Dapper.Dal.Partial.MasterDataManagementRepository _masterManagementRepository;

        public NotificationService(Dapper.Dal.Partial.MasterDataManagementRepository masterManagementRepository)
        {
            _masterManagementRepository = masterManagementRepository;
        }

        public Pubnub GetPubnubService(LoggedInContext loggedInContext)
        {
            PNConfiguration pnConfiguration = new PNConfiguration
            {
                Secure = false,
                HeartbeatNotificationOption = PNHeartbeatNotificationOption.All,
                ReconnectionPolicy = PNReconnectionPolicy.LINEAR,
                LogVerbosity = PNLogVerbosity.BODY
            };

            pnConfiguration.PublishKey = ConfigurationManager.AppSettings["PubnubPublishKey"];
            pnConfiguration.SubscribeKey = ConfigurationManager.AppSettings["PubnubSubscribeKey"];

            if(loggedInContext != null && loggedInContext.LoggedInUserId != null)
            {
                pnConfiguration.Uuid = loggedInContext.LoggedInUserId.ToString();
            }

            return new Pubnub(pnConfiguration);
        }

        private PubnubKeysApiReturnModel GetPubnubKeysFromSettings(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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

        public void SendNotification<T>(T notification, LoggedInContext loggedInContext, Guid? userTobeNotified) where T : NotificationBase
        {
            var pubNubInstance = GetPubnubService(loggedInContext);

            try
            {
                LoggingManager.Debug("Publishing notification: " + notification.ToPubNubNotificationString());

                //TODO: Save the notification to notification, notificationchannel tables via serivce. 
                NotificationModel notificationModel = new NotificationModel
                {
                    NotificationTypeId = notification.NotificationTypeGuid,
                    Summary = notification.Summary,
                    NotificationJson = new JavaScriptSerializer().Serialize(notification)
                };

                notification.NotificationJson = notificationModel.NotificationJson;

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? notificationId = _notificationRepository.UpsertNotification(notificationModel, loggedInContext, validationMessages);

                List<Guid?> notificationIds = new List<Guid?>();

                notificationIds.Add(notificationId);

                string listOfNotificationsXml = Utilities.ConvertIntoListXml(notificationIds);

                //TODO:[UserNotificationRead] - to be populated when we originally sent the notification
                UserNotificationRead userNotification = new UserNotificationRead
                {
                    NotificationId = notificationId,
                    NotificationIdXml = listOfNotificationsXml,
                    UserId = userTobeNotified,
                    OperationsPerformedBy = loggedInContext.LoggedInUserId
                };

                List<Guid?> userNotificationReads = new List<Guid?> { userNotification.NotificationId };

                UpsertUserNotificationRead(userNotificationReads, null, userTobeNotified, loggedInContext, validationMessages);

                if (notificationId != null)
                {
                    notification.Id = notificationId;
                }

                notification.Channels.ForEach(channel =>
                {
                    LoggingManager.Debug("Publishing to channel.. " + channel.ToString());

                    pubNubInstance.Publish()
                        .Message(notification)
                        .Channel(channel)
                        .Execute(new PNPublishResultExt(
                            (result, status) =>
                            {
                                LoggingManager.Debug("pub timetoken: " + result?.Timetoken.ToString());
                                LoggingManager.Debug("pub status code : " + status.StatusCode.ToString());
                                LoggingManager.Debug("pubnub error code: " + status.Error.ToString());
                                LoggingManager.Debug("pubnub error data: " + status.ErrorData?.Information.ToString());
                            }
                        ));

                    var messageDto = new MessageDto
                    {
                        title = NotificationSummaryConstants.NotificationHeader,
                        body = notification.Summary,
                        Id = notification.Id,
                    };

                    MobilePayload payload = new MobilePayload
                    {
                        pn_gcm = new Pn_gcm
                        {
                            notification = messageDto
                        }
                    };

                    payload.pn_gcm.data = new Dictionary<string, string>
                    {
                        { "messageJson", JsonConvert.SerializeObject(messageDto) }
                    };

                    pubNubInstance.Publish()
                        .Message(payload)
                        .Channel(channel)
                        .Execute(new PNPublishResultExt((publishResult, publishStatus) =>
                        {
                            LoggingManager.Debug("pub timetoken: " + publishResult?.Timetoken.ToString());
                            LoggingManager.Debug("pub status code : " + publishStatus.StatusCode.ToString());
                            LoggingManager.Debug("pubnub error code: " + publishStatus.Error.ToString());
                            LoggingManager.Debug("pubnub error data: " + publishStatus.ErrorData?.Information.ToString());
                        }));
                });

                //TODO: Also send the notification based on if the user is subscribed for the notification or not via the usernotification / rolenotification tables.

                //TODO: By default, when a role is created, the person who is able to create the role should also be able to specify all the default notifications
                //TODO: By default, when a user is created or assigned with a role, the person who is able to add/amend the default notifications
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendNotification", "NotificationService ", exception.Message), exception);

            }
            finally
            {
                pubNubInstance.Destroy();
            }
        }

        public void SendPushNotificationsToUser<T>(List<Guid?> userIds, T messageDto) where T : UserStoryAssignedNotification
        {
            try
            {
                foreach (var userId in userIds)
                {
                    var userFcmDetails = _messageRepository.GetFcmDetails(userId.ToString(), true);

                    if (userFcmDetails != null && userFcmDetails.ToList().Count > 0)
                    {
                        //userFcmDetails.ToList().Select(x => x.FcmToken).ToList();
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendPushNotificationsToUser", "NotificationService ", exception.Message), exception);

            }
        }

        public void SendAdhocPushNotificationsToUser<T>(List<Guid?> userIds, T messageDto) where T : AdhocUserStoryAssignedNotification
        {
            try
            {
                foreach (var userId in userIds)
                {
                    var userFcmDetails = _messageRepository.GetFcmDetails(userId.ToString(), true);

                    if (userFcmDetails != null && userFcmDetails.ToList().Count > 0)
                    {
                        var registrationIds = userFcmDetails.ToList().Select(x => x.FcmToken).ToList();
                    }
                }
            }
            catch (Exception exception)
            {
                //  LoggingManager.Error(exception);
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendAdhocPushNotificationsToUser", "NotificationService ", exception.Message), exception);

            }
        }

        public List<NotificationsOutputModel> GetNotifications(NotificationSearchModel notificationSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get notifications", "notificationSearchModel", notificationSearchModel, "notification service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            //LoggingManager.Info("Getting notifications list ");
            //if (string.IsNullOrEmpty(notificationSearchModel.SortBy))
            //{
            //    notificationSearchModel.SortBy = "CreatedDateTime";
            //}

            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/GetNotifications");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var response = client.GetAsync(client.BaseAddress).GetAwaiter().GetResult();
                if (response.IsSuccessStatusCode)
                {
                    string apiResponse = response.Content.ReadAsStringAsync().Result;
                    var notifs = JsonConvert.DeserializeObject<List<NotificationsOutputModel>>(apiResponse);
                    return notifs;
                }
                else
                {
                    return null;
                }
            }            
        }

        public List<Guid?> UpsertUserNotificationRead(List<Guid?> userNotificationRead, DateTime? notificationReadTime, Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            //string notificationIdXml = Utilities.ConvertIntoListXml(userNotificationRead);
            //return _notificationRepository.UpsertUserNotificationRead(notificationIdXml, notificationReadTime, userId, loggedInContext, validationMessages);
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/UpsertReadNewNotifications");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { NotificationIds = userNotificationRead, ReadTime = notificationReadTime, UserId = userId }), Encoding.UTF8, "application/json");
                var response = client.PostAsync(client.BaseAddress, httpContent).GetAwaiter().GetResult();
                if (response.IsSuccessStatusCode)
                {
                    string apiResponse = response.Content.ReadAsStringAsync().Result;
                    var notifs = JsonConvert.DeserializeObject<List<Guid?>>(apiResponse);
                    return notifs;
                }
                else
                {
                    return null;
                }
            }
        }
    }

    public class MobilePayload
    {
        public Pn_gcm pn_gcm { get; set; }
    }

    public class Pn_gcm
    {

        /// <summary>
        /// 
        /// </summary>
        public dynamic notification { get; set; }

        public Dictionary<string, string> data { get; set; }
    }


    public class DemoPublishResult : PNCallback<PNPublishResult>
    {
        public override void OnResponse(PNPublishResult result, PNStatus status)
        {
            // handle publish result.
        }
    };


}