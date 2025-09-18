using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Employee
{
    public class EmployeeListApiOutputModel
    {

        public Guid? EmployeeId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? Value { get; set; }
        public string FullName { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string BranchName { get; set; }
        public string ProfileImage { get; set; }
        public string EmployeeNumber { get; set; }
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public string DepartmentName { get; set; }
        public string EmploymentStatusName { get; set; }
        public string DesignationName { get; set; }
        public string JobCategoryType { get; set; }
        public string Shift { get; set; }
        public bool TrackEmployee { get; set; }
        public Guid? ActivityTrackerUserId { get; set; }
        public Guid? ActivityTrackerAppUrlTypeId { get; set; }
        public int ScreenShotFrequency { get; set; }
        public int Multiplier { get; set; }
        public byte[] ATUTimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", EmployeeNumber = " + EmployeeNumber);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", DepartmentName = " + DepartmentName);
            stringBuilder.Append(", EmploymentStatusName = " + EmploymentStatusName);
            stringBuilder.Append(", DesignationName = " + DesignationName);
            stringBuilder.Append(", DateOfJoining = " + DateOfJoining);
            stringBuilder.Append(", JobCategoryType = " + JobCategoryType);
            stringBuilder.Append(", Shift = " + Shift);
            return stringBuilder.ToString();
        }
    }
    public class UserListApiOutputModel
    {
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public Guid? UserId { get; set; }
        public Guid? Value { get; set; }
        public string FullName { get; set; }
    }
}
 
