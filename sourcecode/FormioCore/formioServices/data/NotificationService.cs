using Formio.Hubs;
using formioCommon.Constants;
using formioModels;
using formioModels.Data;
using formioRepo.DataSet;
using formioRepo.DataSource;
using formioRepo.DataSourceKeys;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public class NotificationService : INotificationService
    {
        private readonly IDataSourceRepository _dataSourceRepository;
        private readonly IHubContext<LookupSyncNotification, IHubClient> _hubContext;

        public NotificationService(IDataSourceRepository dataSourceRepository,
            IHubContext<LookupSyncNotification, IHubClient> hubContext)
        {
            _dataSourceRepository = dataSourceRepository;
            _hubContext = hubContext;
        }
        public void NotificationAlertWorkFlow(NotificationAlertModel alertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<NotifyToUserModel> usersToNotify = new List<NotifyToUserModel>();
                if(!string.IsNullOrEmpty(alertModel.NotifyToUsersJson))
                {
                    usersToNotify = JsonConvert.DeserializeObject<List<NotifyToUserModel>>(alertModel.NotifyToUsersJson);
                }
                if(usersToNotify.Count > 0)
                {
                    foreach (var user in usersToNotify)
                    {
                        var notification = _dataSourceRepository.UpsertNotification(new NotificationModel
                        {
                            Id = Guid.NewGuid(),
                            NotificationType = alertModel.NotificationType,
                            Summary = alertModel.NotificationText,
                            NavigationUrl = alertModel.NavigationUrl,
                            CreatedDateTime = DateTime.UtcNow,
                            NotifyToUserId = user.UserId,
                            IsArchived = false,
                            CreatedByUserId = loggedInContext.LoggedInUserId,
                            ReadTime = null,
                            InActiveDateTime = null,
                            UpdatedByUserId = null,
                            UpdatedDateTime = null
                        }, loggedInContext, validationMessages);

                        if (notification != null)
                        {
                            var con = UserHandler.GetConnections(user.FullName);
                            if (con.Count() > 0)
                            {
                                foreach (var c in con)
                                {
                                    _hubContext.Clients.Client(c).BroadCastNotification(notification);
                                }
                            }
                        }
                    }
                }
                else
                {
                    var notification = _dataSourceRepository.UpsertNotification(new NotificationModel
                    {
                        Id = Guid.NewGuid(),
                        NotificationType = alertModel.NotificationType,
                        Summary = alertModel.NotificationText,
                        NavigationUrl = alertModel.NavigationUrl,
                        CreatedDateTime = DateTime.UtcNow,
                        NotifyToUserId = loggedInContext.LoggedInUserId,
                        IsArchived = false,
                        CreatedByUserId = loggedInContext.LoggedInUserId,
                        ReadTime = null,
                        InActiveDateTime = null,
                        UpdatedByUserId = null,
                        UpdatedDateTime = null
                    }, loggedInContext, validationMessages);

                    if (notification != null)
                    {
                        var con = UserHandler.GetConnections(loggedInContext.FullName);
                        if (con.Count() > 0)
                        {
                            foreach (var c in con)
                            {
                                _hubContext.Clients.Client(c).BroadCastNotification(notification);
                            }
                        }
                    }
                }

               

            }
            catch (Exception exception) 
            {
                LoggingManager.Error("sending notification failed with exception :- " + exception);
            }
        }
    }
}
