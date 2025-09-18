using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class PermissionRegisterReturnOutputModel
    {
        public DateTime? Date { get; set; }
        public string EmployeeName { get; set; }
        public string UserProfileImage { get; set; }
        public Guid UserId { get; set; }
        public Guid EmployeeId { get; set; }
        public DateTime?  DateOfPermission { get; set; }
        public TimeSpan Duration { get; set; }
        public string PermissionReason { get; set; }
        public string Review { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", UserProfileImage = " + UserProfileImage);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", DateOfPermission = " + DateOfPermission);
            stringBuilder.Append(", Duration = " + Duration);
            stringBuilder.Append(", PermissionReason = " + PermissionReason);
            stringBuilder.Append(", Review = " + Review);
            stringBuilder.Append(", TotalCount=" + TotalCount);
            return stringBuilder.ToString();
        }
    }
}