using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TimeUsageOfApplicationSearchOutputModel : InputModelBase
    {
        public TimeUsageOfApplicationSearchOutputModel() : base(InputTypeGuidConstants.TimeUsageOfApplicationSearchOutputCommandTypeGuid)
        {

        }
        public Guid UserId { get; set; }
        public string Name { get; set; }
        public DateTime OperationDate { get; set; }
        public TimeSpan Neutral { get; set; }
        public TimeSpan Productive { get; set; }
        public TimeSpan UnProductive { get; set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(",Name" + Name);
            stringBuilder.Append(",OperationDate" + OperationDate);
            stringBuilder.Append(", Productive = " + Productive);
            stringBuilder.Append(", UnProductive = " + UnProductive);
            stringBuilder.Append(", Neutral = " + Neutral);
            return stringBuilder.ToString();
        }
    }
}
