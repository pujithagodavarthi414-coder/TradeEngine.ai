using System;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class LateEmployeeOutputModel
    {
        public Guid? UserId { get; set; }
        public string FullName { get; set; }
        public string DaysLateFor { get; set; }
        public int? DaysLate { get; set; }
        public int? PermittedDays { get; set; }
        public int? DaysWithOutPermission { get; set; }
        public string SpentTime { get; set; }
        public int? DaysMoreTimeSpent { get; set; }
        public int? TotalCount { get; set; }
        public string ProfileImage { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", DaysLateFor = " + DaysLateFor);
            stringBuilder.Append(", DaysLate = " + DaysLate);
            stringBuilder.Append(", PermittedDays = " + PermittedDays);
            stringBuilder.Append(", DaysWithOutPermission = " + DaysWithOutPermission);
            stringBuilder.Append(", SpentTime = " + SpentTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", DaysMoreTimeSpent = " + DaysMoreTimeSpent);
            return stringBuilder.ToString();
        }
    }
}
