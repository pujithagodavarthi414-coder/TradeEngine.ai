using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class PayGradeSearchInputModel : InputModelBase
    {
        public PayGradeSearchInputModel() : base(InputTypeGuidConstants.PayGradeSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayGradeId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayGradeId = " + PayGradeId);
            stringBuilder.Append(", SearchText    = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
