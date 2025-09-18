using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class ProjectFeatureNotificationModel : NotificationBase
    {
        public Guid? ProjectFeatureId { get; }
        public string ProjectFeatureName { get; }
        public Guid? ProjectId { get; }
        public string ProjectName { get; }

        public ProjectFeatureNotificationModel(string summary,
            Guid? projectFeatureId, string projectFeatureName,
            Guid? projectFeatureResponsibleGuid) : base(NotificationTypeConstants.ProjectFeature, summary
        )
        {
            ProjectFeatureId = projectFeatureId;
            ProjectFeatureName = projectFeatureName;
            ProjectId = projectFeatureResponsibleGuid;
            Channels.Add(string.Format(NotificationChannelNamesConstants.ProjectFeature, projectFeatureResponsibleGuid));
        }
    }
}