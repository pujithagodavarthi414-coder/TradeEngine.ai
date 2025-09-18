using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ScheduleTypeInputModel : InputModelBase
    {
        public ScheduleTypeInputModel() : base(InputTypeGuidConstants.ScheduleTypeInputCommandTypeGuid)
        {
        }

        public Guid? ScheduleTypeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ScheduleTypeId" + ScheduleTypeId);
            return base.ToString();
        }
    }
}
