using System;
using System.Text;
using System.Collections.Generic;

namespace Btrak.Models.Employee
{
    public class EmployeeOutputModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? UserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string FullName => FirstName + " " + SurName;
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? MaritalStatusId { get; set; }
        public DateTime? MarriageDate { get; set; }
        public string MaritalStatus { get; set; }
        public Guid? NationalityId { get; set; }
        public string Nationality { get; set; }
        public Guid? GenderId { get; set; }
        public string Gender { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public bool Smoker { get; set; }
        public bool MilitaryService { get; set; }
        public string NickName { get; set; }
        public string TaxCode { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public string RoleId { get; set; }
        public string RoleName { get; set; }
        public bool IsActive { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string TimeZoneName { get; set; }
        public string MobileNo { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public DateTime? LastConnection { get; set; }
        public byte[] TimeStamp { get; set; }
        public string EmployeeNumber { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public bool IsTerminated { get; set; }
        public string ProfileImage { get; set; }
        public Guid? DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public string EmploymentStatusName { get; set; }
        public Guid? DesignationId { get; set; }
        public string DesignationName { get; set; }
        public Guid? JobCategoryId { get; set; }
        public string JobCategoryType { get; set; }
        public Guid? ShiftTimingId { get; set; }
        public string Shift { get; set; }
        public Guid? CurrencyId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public string[] RoleIds { get; set; }
        public string[] RoleNames { get; set; }
        public string PermittedBranchIds { get; set; }
        public string PermittedBranchNames { get; set; }
        public string BusinessUnitIds { get; set; }
        public string BusinessUnitNames { get; set; }
        public string MacAddress { get; set; }
        public bool TrackEmployee { get; set; }
        public Guid? ActivityTrackerUserId { get; set; }
        public Guid? ActivityTrackerAppUrlTypeId { get; set; }
        public int ScreenShotFrequency { get; set; }
        public int Multiplier { get; set; }
        public bool? IsTrack { get; set; }
        public bool? IsScreenshot { get; set; }
        public bool? IsKeyboardTracking { get; set; }
        public bool? IsMouseTracking { get; set; }
        public byte[] ATUTimeStamp { get; set; }
        public Guid? EmployeeShiftId { get; set; }
        public string IPNumber { get; set; }
        public string FormData { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", EmployeeNumber = " + EmployeeNumber);
            stringBuilder.Append(", GenderId = " + GenderId);
            stringBuilder.Append(", Gender = " + Gender);
            stringBuilder.Append(", MaritalStatusId = " + MaritalStatusId);
            stringBuilder.Append(", MarriageDate = " + MarriageDate);
            stringBuilder.Append(", MaritalStatus = " + MaritalStatus);
            stringBuilder.Append(", NationalityId = " + NationalityId);
            stringBuilder.Append(", Nationality = " + Nationality);
            stringBuilder.Append(", DateOfBirth = " + DateOfBirth);
            stringBuilder.Append(", Smoker = " + Smoker);
            stringBuilder.Append(", MilitaryService = " + MilitaryService);
            stringBuilder.Append(", NickName = " + NickName);
            stringBuilder.Append(", TaxCode = " + TaxCode);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", RoleName = " + RoleName);
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            stringBuilder.Append(", TimeZoneName = " + TimeZoneName);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            stringBuilder.Append(", IsTerminated = " + IsTerminated);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", IsActiveOnMobile = " + IsActiveOnMobile);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", LastConnection = " + LastConnection);
            stringBuilder.Append(", RegisteredDateTime = " + RegisteredDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", DepartmentId = " + DepartmentId);
            stringBuilder.Append(", DepartmentName = " + DepartmentName);
            stringBuilder.Append(", EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", EmploymentStatusName = " + EmploymentStatusName);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", DesignationName = " + DesignationName);
            stringBuilder.Append(", DateOfJoining = " + DateOfJoining);
            stringBuilder.Append(", JobCategoryId = " + JobCategoryId);
            stringBuilder.Append(", JobCategoryType = " + JobCategoryType);
            stringBuilder.Append(", ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", Shift = " + Shift);
            stringBuilder.Append(", MacAddress = " + MacAddress);
            stringBuilder.Append(", EmployeeShiftId = " + EmployeeShiftId);
            stringBuilder.Append(", IPNumber = " + IPNumber);
            stringBuilder.Append(", FormData = " + FormData);
            return stringBuilder.ToString();
        }
    }
}
