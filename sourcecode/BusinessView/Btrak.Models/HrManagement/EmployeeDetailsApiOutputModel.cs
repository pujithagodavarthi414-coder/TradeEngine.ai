using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeDetailsApiOutputModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? UserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public string BranchName { get; set; }
        public bool IsActive { get; set; }
        public string EmployeeNumber { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public string ProfileImage { get; set; }
        public string DepartmentName { get; set; }
        public string EmploymentStatusName { get; set; }
        public string DesignationName { get; set; }
        public string JobCategoryType { get; set; }
        public string Shift { get; set; }
        public bool TrackEmployee { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", EmployeeNumber = " + EmployeeNumber);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", DepartmentName = " + DepartmentName);
            stringBuilder.Append(", EmploymentStatusName = " + EmploymentStatusName);
            stringBuilder.Append(", DesignationName = " + DesignationName);
            stringBuilder.Append(", DateOfJoining = " + DateOfJoining);
            stringBuilder.Append(", JobCategoryType = " + JobCategoryType);
            stringBuilder.Append(", Shift = " + Shift);
            return stringBuilder.ToString();
        }
    }
}
