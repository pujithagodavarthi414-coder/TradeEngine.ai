using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Status
{
    public class UpsertBugPriorityInputModel : InputModelBase
    {
        public UpsertBugPriorityInputModel() : base(InputTypeGuidConstants.UpsertBugPriorityCommandTypeGuid)
        {
        }

        public Guid? BugPriorityId { get; set; }
        public string PriorityName { get; set; }
        public string Color { get; set; }
        public string Icon { get; set; }
        public int? Order { get; set; }
        public string Description { get; set; }
        public string TimeZone { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BugPriorityId = " + BugPriorityId);
            stringBuilder.Append(", PriorityName = " + PriorityName);
            stringBuilder.Append(", Color = " + Color);
            stringBuilder.Append(", Icon = " + Icon);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", Description" + Description);
            stringBuilder.Append(", IsArchived" + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
