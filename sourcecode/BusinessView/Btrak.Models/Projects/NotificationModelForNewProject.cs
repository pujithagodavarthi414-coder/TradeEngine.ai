using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class NotificationModelForNewProject : NotificationBase
    {
        public Guid? ProjectGuid { get; }
        public string ProjectName { get; }
        public Guid? ProjectResponsiblePersonId { get; }

        public NotificationModelForNewProject(string summary,
            Guid? projectGuid,
            string projectName,Guid? projectResponsiblePersonId) : base(NotificationTypeConstants.NewProject, summary
        )
        {
            ProjectGuid = projectGuid;
            ProjectName = projectName;
            ProjectResponsiblePersonId = projectResponsiblePersonId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.NewProject, projectResponsiblePersonId));
        }
    }
}

