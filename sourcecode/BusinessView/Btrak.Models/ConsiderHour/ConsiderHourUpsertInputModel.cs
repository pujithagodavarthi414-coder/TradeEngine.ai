using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ConsiderHour
{
    public class ConsiderHourUpsertInputModel : InputModelBase
    {
        public ConsiderHourUpsertInputModel() : base(InputTypeGuidConstants.ConsiderHourUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ConsiderHourId { get; set; }
        public string ConsiderHourName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ConsiderHourId = " + ConsiderHourId);
            stringBuilder.Append(", ConsiderHourName = " + ConsiderHourName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
