using BTrak.Common;
using BTrak.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Notification
{
    public class NotificationModelForSprintReplan : NotificationBase
    {
        public Guid? SprintGuid { get; }
        public string SprintName { get; }

        public NotificationModelForSprintReplan(string summary,
            Guid? sprintResponsibleGuid,
            string sprintName,
            Guid? sprintGuid) : base(NotificationTypeConstants.SprintReplan, summary
        )
        {
            SprintGuid = sprintGuid;
            SprintName = sprintName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.SprintReplan, sprintResponsibleGuid));
        }
    }
}
