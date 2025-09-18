using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class NotificationModelForArchiveProject : NotificationBase
    {
        public Guid? ProjectGuid { get; }
        public string ProjectName { get; }

        public NotificationModelForArchiveProject(string summary,
            Guid? projectGuid,
            string projectName) : base(NotificationTypeConstants.ArchiveProject, summary
        )
        {
            ProjectGuid = projectGuid;
            ProjectName = projectName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.ArchiveProject, ProjectGuid));
        }
    }
}
