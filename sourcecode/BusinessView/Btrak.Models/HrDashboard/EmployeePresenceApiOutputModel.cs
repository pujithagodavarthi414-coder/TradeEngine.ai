using System;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class EmployeePresenceApiOutputModel
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string Status { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
