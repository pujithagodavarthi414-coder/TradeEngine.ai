using System;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class LineManagersOutputModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? EmployeeId { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            return stringBuilder.ToString();
        }
    }
}
