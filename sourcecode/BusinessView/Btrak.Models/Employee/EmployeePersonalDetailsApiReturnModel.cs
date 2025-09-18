using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeePersonalDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public string EmployeeNumber { get; set; }   
        public Guid? UserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string ProfileImage { get; set; }
        public Guid? NationalityId { get; set; }
        public string Nationality { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public bool? Smoker { get; set; }
        public bool? MilitaryService { get; set; }
        public string NickName { get; set; }
        public string TaxCode { get; set; }
        public Guid? GenderId { get; set; }
        public string Gender { get; set; }
        public Guid? MaritalStatusId { get; set; }
        public DateTime? MarriageDate { get; set; }
        public string MaritalStatus { get; set; }
        public string RoleId { get; set; }
        public string RoleName { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string TimeZoneName { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsActiveOnMobile { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public DateTime? LastConnection { get; set; }
        public string MobileNo { get; set; }
        public string Password { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? DesignationId { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public Guid? JobCategoryId { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public Guid? CurrencyId { get; set; }
        public string PermittedBranchIds { get; set; }
        public string PermittedBranchNames { get; set; }
        public string IPNumber { get; set; }
        public string MACAddress { get; set; }
        public Guid? DepartmentId { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeNumber = " + EmployeeNumber);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", Surname = " + SurName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", NationalityId = " + NationalityId);
            stringBuilder.Append(", Nationality = " + Nationality);
            stringBuilder.Append(", TaxCode = " + TaxCode);
            stringBuilder.Append(", Smoker = " + Smoker);
            stringBuilder.Append(", DateOfJoining = " + DateOfJoining);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", JobCategoryId = " + JobCategoryId);
            stringBuilder.Append(", MilitaryService = " + MilitaryService);
            stringBuilder.Append(", NickName = " + NickName);
            stringBuilder.Append(", DateOfBirth = " + DateOfBirth);
            stringBuilder.Append(", GenderId = " + GenderId);
            stringBuilder.Append(", Gender = " + Gender);
            stringBuilder.Append(", MaritalStatusId = " + MaritalStatusId);
            stringBuilder.Append(", MarriageDate = " + MarriageDate);
            stringBuilder.Append(", MaritalStatus = " + MaritalStatus);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", RoleName = " + RoleName);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", TimeZoneName = " + TimeZoneName);
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", IsActiveOnMobile = " + IsActiveOnMobile);
            stringBuilder.Append(", RegisteredDateTime = " + RegisteredDateTime);
            stringBuilder.Append(", LastConnection = " + LastConnection);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            stringBuilder.Append(", Password = " + Password);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", PermittedBranchIds = " + PermittedBranchIds);
            stringBuilder.Append(", PermittedBranchNames = " + PermittedBranchNames);
            stringBuilder.Append(", IPNumber = " + IPNumber);
            stringBuilder.Append(", MACAddress = " + MACAddress);
            stringBuilder.Append(", DepartmentId = " + DepartmentId);
            return stringBuilder.ToString();
        }
    }
}
