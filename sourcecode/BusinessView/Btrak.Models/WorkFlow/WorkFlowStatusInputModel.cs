using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowStatusInputModel : InputModelBase
    {
        public WorkFlowStatusInputModel() : base(InputTypeGuidConstants.WorkFlowStatusInputCommandTypeGuid)
        {
        }

        public Guid? WorkFlowStatusId { get; set; }
        public Guid? WorkFlowId { get; set; }

        public int? OrderId { get; set; }
        public bool? IsCompleted { get; set; }
        public bool? IsBlocked { get; set; }
        public bool? IsArchived { get; set; }

        public Guid? UserStoryStatusId { get; set; }
        public Guid? ExistingUserStoryStatusId { get; set; }
        public Guid? CurrentUserStoryStatusId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkFlowStatusId = " + WorkFlowStatusId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", OrderId = " + OrderId);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsBlocked = " + IsBlocked);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", ExistingUserStoryStatusId = " + ExistingUserStoryStatusId);
            stringBuilder.Append(", CurrentUserStoryStatusId = " + CurrentUserStoryStatusId);
            return stringBuilder.ToString();
        }
    }
}
