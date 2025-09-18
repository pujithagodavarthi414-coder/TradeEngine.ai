using System;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class LeavesReportOutputModel
    {
        public Guid? UserId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeProfileImage { get; set; }
        public string EmployeeId { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public string BranchName { get; set; }
        public float? TotalLeaves { get; set; }
        public float? EligibleLeaves { get; set; }
        public float? EligibleLeavesYTD { get; set; }
        public float? LeavesTaken { get; set; }
        public float? OnsiteLeaves { get; set; }
        public float? WorkFromHomeLeaves { get; set; }
        public float? UnplannedLeaves { get; set; }
        public float? UnpaidLeaves { get; set; }
        public float? PaidLeaves { get; set; }
        public int? SpentTime { get; set; }
        public float? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", EmployeeProfileImage = " + EmployeeProfileImage);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", DateOfJoining = " + DateOfJoining);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", EligibleLeaves = " + EligibleLeaves);
            stringBuilder.Append(", SpentTime = " + SpentTime);
            stringBuilder.Append(", EligibleLeavesYTD = " + EligibleLeavesYTD);
            stringBuilder.Append(", LeavesTaken = " + LeavesTaken);
            stringBuilder.Append(", OnsiteLeaves = " + OnsiteLeaves);
            stringBuilder.Append(", WorkFromHomeLeaves = " + WorkFromHomeLeaves);
            stringBuilder.Append(", UnplannedLeaves = " + UnplannedLeaves);
            stringBuilder.Append(", UnpaidLeaves = " + UnpaidLeaves);
            stringBuilder.Append(", PaidLeaves = " + PaidLeaves);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
