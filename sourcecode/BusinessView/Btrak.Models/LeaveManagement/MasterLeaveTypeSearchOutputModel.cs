using System;
using System.Text;

namespace Btrak.Models.LeaveManagement
{
    public class MasterLeaveTypeSearchOutputModel
    {
        public Guid? MasterLeaveTypeId { get; set; }
        public string MasterLeaveTypeName { get; set; }
        public bool? IsCasualLeave { get; set; }
        public bool? IsOnSite { get; set; }
        public bool? IsSickLeave { get; set; }
        public bool? IsWithoutIntimation { get; set; }
        public bool? IsWorkFromHome { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", MasterLeaveTypeId = " + MasterLeaveTypeId);
            stringBuilder.Append(", MasterLeaveTypename = " + MasterLeaveTypeName);
            stringBuilder.Append(", IsCasualLeave = " + IsCasualLeave);
            stringBuilder.Append(", IsOnSite = " + IsOnSite);
            stringBuilder.Append(", IsSickLeave = " + IsSickLeave);
            stringBuilder.Append(", IsWithoutIntimation = " + IsWithoutIntimation);
            stringBuilder.Append(", IsWorkFromHome = " + IsWorkFromHome);
            return stringBuilder.ToString();
        }

    }
}
