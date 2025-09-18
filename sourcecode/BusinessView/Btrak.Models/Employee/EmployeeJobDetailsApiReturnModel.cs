using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeJobDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeJobDetailId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? DesignationId { get; set; }
        public string DesignationName { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public string EmploymentStatus { get; set; }
        public bool? IsPermanent { get; set; }
        public Guid? JobCategoryId { get; set; }
        public string JobCategoryName { get; set; }
        public DateTime? JoinedDate { get; set; }
        public Guid? DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public int? NoticePeriodInMonths { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeJobDetailId = " + EmployeeJobDetailId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", DesignationName = " + DesignationName);
            stringBuilder.Append(", EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", EmploymentStatus = " + EmploymentStatus);
            stringBuilder.Append(", IsPermanent = " + IsPermanent);
            stringBuilder.Append(", JobCategoryId = " + JobCategoryId);
            stringBuilder.Append(", JobCategoryName = " + JobCategoryName);
            stringBuilder.Append(", JoinedDate = " + JoinedDate);
            stringBuilder.Append(", DepartmentId = " + DepartmentId);
            stringBuilder.Append(", DepartmentName = " + DepartmentName);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", NoticePeriodInMonths = " + NoticePeriodInMonths);
            return stringBuilder.ToString();
        }
    }
}
