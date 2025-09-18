using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class UpsertCronExpressionApiReturnModel
    {
        public Guid? UserId { get; set; }

        public int? JobId { get; set; }

        public int? NextHangFireJobId { get; set; }

        public Guid? CronExpressionId { get; set; }

        public string CronExpressionName { get; set; }

        public byte[] TimeStamp { get; set; }

        public string CronExpression { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();

            stringBuilder.Append("JobId = " + JobId);

            stringBuilder.Append("NextHangFireJobId = " + NextHangFireJobId);

            stringBuilder.Append("UserId = " + UserId);

            stringBuilder.Append("CronExpressionId = " + CronExpressionId);

            stringBuilder.Append("CronExpressionName = " + CronExpressionName);

            return stringBuilder.ToString();
        }
    }
}
