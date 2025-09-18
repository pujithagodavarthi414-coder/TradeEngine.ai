using BTrak.Common;
using BTrak.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Notification
{
    public class NotificationModelForSprintStarted : NotificationBase
    {
        public Guid? SprintGuid { get; }
        public string SprintName { get; }

        public NotificationModelForSprintStarted(string summary,
            Guid? sprintResponsibleGuid,
            string sprintName,
            Guid? sprintGuid) : base(NotificationTypeConstants.SprintStarted, summary
        )
        {
            SprintGuid = sprintGuid;
            SprintName = sprintName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.SprintStarted, sprintResponsibleGuid));
        }
    }
}
