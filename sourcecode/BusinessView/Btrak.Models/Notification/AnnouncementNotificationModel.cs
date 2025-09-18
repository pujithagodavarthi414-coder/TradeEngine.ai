using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class AnnouncementNotificationModel : NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? AnnouncementId { get; }
        public string Announcement { get; }
        public string AnnouncedBy { get; }
        public DateTime AnnouncedOn { get; }
        public Guid? AnnouncedById { get; }
        public string AnnouncedByUserImage { get; }
        public AnnouncementNotificationModel(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid,
                                             Guid? announcementId,
                                             string announcement,
                                             string announcedBy,
                                             DateTime announcedOn,
                                             Guid? announcedById,
                                             string announcedByUserImage) : base(NotificationTypeConstants.AnnouncementReceivedNotificationTypeId, summary
            )
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            AnnouncementId = announcementId;
            Announcement = announcement;
            AnnouncedBy = announcedBy;
            AnnouncedOn = announcedOn;
            AnnouncedById = announcedById;
            AnnouncedByUserImage = announcedByUserImage;
            Channels.Add(string.Format(NotificationChannelNamesConstants.AnnouncementNotification, notificationAssignedToUserGuid));
        }

    }
}
