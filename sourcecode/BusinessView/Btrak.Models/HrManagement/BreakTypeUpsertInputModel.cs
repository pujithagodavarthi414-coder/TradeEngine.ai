using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class BreakTypeUpsertInputModel : InputModelBase
    {
        public BreakTypeUpsertInputModel() : base(InputTypeGuidConstants.BreakTypeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? BreakId { get; set; }
        public string BreakTypeName { get; set; }
        public bool IsPaid { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BreakId = " + BreakId);
            stringBuilder.Append(", BreakTypeName = " + BreakTypeName);
            stringBuilder.Append(", IsPaid = " + IsPaid);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}