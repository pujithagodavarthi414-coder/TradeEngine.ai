using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ScheduleSequenceInputModel : InputModelBase
    {
        public ScheduleSequenceInputModel() : base(InputTypeGuidConstants.ScheduleSequenceInputCommandTypeGuid)
        {
        }

        public Guid? ScheduleSequenceId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ScheduleSequenceId" + ScheduleSequenceId);
            return base.ToString();
        }
    }
}
