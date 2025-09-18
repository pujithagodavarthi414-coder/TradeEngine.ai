using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TimeUsageOfApplicationApiOutputModel
    {
        public string Name { get; set; }
        public string ProfileImage { get; set; }
        public Guid UserId { get; set; }
        public List<DateTime> Dates { get; set; }
        public DateTime OperationDate { get; set; }
        public Double Productive { get; set; }
        public Double UnProductive { get; set; }
        public Double Neutral { get; set; }
        public Double Idle { get; set; }
        public Double TotalTime { get; set; }
        public int TotalCount { get; set; }
        public List<TimeUsageSearchOutputModel> timeUsageSearchOutputModel { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeName = " + Name);
            stringBuilder.Append(", Id =" + UserId);
            return stringBuilder.ToString();
        }
    }
}
