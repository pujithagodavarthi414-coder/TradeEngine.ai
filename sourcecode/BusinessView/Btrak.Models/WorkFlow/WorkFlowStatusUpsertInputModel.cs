using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowStatusUpsertInputModel : InputModelBase
    {
        public WorkFlowStatusUpsertInputModel() : base(InputTypeGuidConstants.WorkFlowStatusUpsertInputCommandTypeGuid)
        {
        }

        public Guid? WorkFlowStatusId { get; set; }
        public Guid? WorkFlowId { get; set; }

        public int? OrderId { get; set; }
        public bool? IsCompleted { get; set; }
        public bool? IsBlocked { get; set; }
        public bool IsArchived { get; set; }
        public string TimeZone { get; set; }

        public Guid? CanAdd { get; set; }
        public Guid? CanDelete { get; set; }
        public List<Guid> StatusId { get; set; }
        public string StatusIdXml { get; set; }

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
            stringBuilder.Append(", TimeZone = " + TimeZone);
            stringBuilder.Append(", IsBlocked = " + IsBlocked);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", StatusIdXml = " + StatusIdXml);
            return stringBuilder.ToString();
        }
    }
}
