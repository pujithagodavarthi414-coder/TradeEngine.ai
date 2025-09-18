using System;
using System.Text;

namespace Btrak.Models.SeatingArrangement
{
    public class SeatingArrangementOutputModel
    {
        public Guid SeatingId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid BranchId { get; set; }
        public string BranchName { get; set; }
        public string SeatCode { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeProfileImage { get; set; }
        public string CreatedOn { get; set; }
        public string TotalCount { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? UpdatedOn { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", SeatingId = " + SeatingId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", SeatCode = " + SeatCode);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", EmployeeProfileImage = " + EmployeeProfileImage);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedOn = " + UpdatedOn);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
