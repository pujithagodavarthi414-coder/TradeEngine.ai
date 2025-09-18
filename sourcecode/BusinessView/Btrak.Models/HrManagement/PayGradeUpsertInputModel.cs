using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class PayGradeUpsertInputModel : InputModelBase
    {
        public PayGradeUpsertInputModel() : base(InputTypeGuidConstants.PayGradeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? PayGradeId { get; set; }
        public string PayGradeName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayGradeId = " + PayGradeId);
            stringBuilder.Append(", PayGradeName = " + PayGradeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
