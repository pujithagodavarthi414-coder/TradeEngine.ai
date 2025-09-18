using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Notification;
using BTrak.Common;

namespace Btrak.Services.Notification
{
    public interface INotificationService
    {
        void SendNotification<T>(T notification,LoggedInContext loggedInContext, Guid? userTobeNotified) where T: NotificationBase;
        void SendPushNotificationsToUser<T>(List<Guid?> userIds, T messageDto) where T : UserStoryAssignedNotification;
        List<NotificationsOutputModel> GetNotifications(NotificationSearchModel notificationSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> UpsertUserNotificationRead(List<Guid?> userNotificationRead, DateTime? NotificationReadTime,Guid? UserId,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //List<Guid?> UpsertReadNewNotifications(List<Guid?> userNotificationRead, DateTime? NotificationReadTime, Guid? UserId,
        //    LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}