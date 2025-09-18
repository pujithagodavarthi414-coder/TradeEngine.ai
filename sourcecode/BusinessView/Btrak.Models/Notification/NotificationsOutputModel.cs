using System;

namespace Btrak.Models.Notification
{
    public class NotificationsOutputModel
    {
        public Guid NotificationId { get; set; }
        public Guid? NotificationTypeId { get; set; }
        public string NotificationTypeName { get; set; }
        public Guid? FeatureId { get; set; }
        public string FeatureName { get; set; }
        public string NotificationJson { get; set; }
        public string NotificationSummary { get; set; }
        public DateTime NotificationCreatedDateTime { get; set; }
        public Guid? Id { get; set; }
        public string NotificationType { get; set; }
        public string Summary { get; set; }
        public DateTime? ReadTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool? IsArchived { get; set; }
        public string NavigationUrl { get; set; }
    }
}
