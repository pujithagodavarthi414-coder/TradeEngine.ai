using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeOverViewDetailsOutputModel
    {
        public Guid? EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public DateTimeOffset? DateOfJoining { get; set; }
        public string BranchName { get; set; }
        public Guid? BranchId { get; set; }
        public string CompanyName { get; set; }
        public Guid? CompanyId { get; set; }
        public string PhoneNumber { get; set; }
        public string EmailId { get; set; }
        public string CurrencyCode { get; set; }
        public Guid? CurrencyId { get; set; }
        public string ApprovedLeaves { get; set; }
        public string RemainingLeaves { get; set; }
        public string ProfileImage { get; set; }
        public int? Leaves { get; set; }
        public decimal? ProductivityIndex { get; set; }
        public decimal? CanteenCredit { get; set; }
        public decimal? MorningLateDaysCount { get; set; }
        public decimal? LunchLateDaysCount { get; set; }
        public decimal? MorningAndAfternoonLateDaysCount { get; set; }
        public decimal? SpentTime { get; set; }
        public string IPNumber { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", DateOfJoining = " + DateOfJoining);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", CompanyName = " + CompanyName);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", PhoneNumber = " + PhoneNumber);
            stringBuilder.Append(", EmailId = " + EmailId);
            stringBuilder.Append(", CurrencyCode = " + CurrencyCode);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", ApprovedLeaves = " + ApprovedLeaves);
            stringBuilder.Append(", RemainingLeaves = " + RemainingLeaves);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", Leaves = " + Leaves);
            stringBuilder.Append(", ProductivityIndex = " + ProductivityIndex);
            stringBuilder.Append(", CanteenCredit = " + CanteenCredit);
            stringBuilder.Append(", MorningLateDaysCount = " + MorningLateDaysCount);
            stringBuilder.Append(", LunchLateDaysCount = " + LunchLateDaysCount);
            stringBuilder.Append(", MorningAndAfternoonLateDaysCount = " + MorningAndAfternoonLateDaysCount);
            stringBuilder.Append(", SpentTime = " + SpentTime);
            stringBuilder.Append(", IPNumber = " + IPNumber);
            return stringBuilder.ToString();
        }
    }
}
