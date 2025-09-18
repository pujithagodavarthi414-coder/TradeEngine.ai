using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class BreakTypeSearchInputModel : InputModelBase
    {
        public BreakTypeSearchInputModel() : base(InputTypeGuidConstants.BreakTypeSearchInputCommandTypeGuid)
        {
        }

        public Guid? BreakTypeId { get; set; }
        public string BreakTypeName { get; set; }
        public string SearchText { get; set; }
        public bool IsPaid { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BreakTypeId = " + BreakTypeId);
            stringBuilder.Append(", BreakTypeName = " + BreakTypeName);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", IsPaid = " + IsPaid);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
