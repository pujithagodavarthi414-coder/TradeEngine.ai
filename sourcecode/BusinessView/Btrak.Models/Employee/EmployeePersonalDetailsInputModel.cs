using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeePersonalDetailsInputModel : InputModelBase
    {
        public EmployeePersonalDetailsInputModel() : base(InputTypeGuidConstants.EmployeePersonalDetailsInputCommandTypeGuid)
        {
        }

        public Guid? UserId { get; set; }
        public Guid? EmployeeId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public Guid? NationalityId { get; set; }
        public string TaxCode { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public Guid? GenderId { get; set; }
        public Guid? MaritalStatusId { get; set; }
        public DateTime? MarriageDate { get; set; }
        public string RoleIds { get; set; }
        public bool? IsActive { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public bool? IsActiveOnMobile { get; set; }
        public string MobileNo { get; set; }
        public string Password { get; set; }
        public bool? IsArchived { get; set; }
        public string EmployeeNumber { get; set; }
        public Guid? DesignationId { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public Guid? JobCategoryId { get; set; }
        public Guid? ShiftTimingId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? TimeZoneId { get; set; }
        public Guid? CurrencyId { get; set; }
        public bool? IsUpsertEmployee { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public List<Guid?> PermittedBranches { get; set; } 
        public List<Guid?> BusinessUnitIds { get; set; } 
        public string PermittedBranchIds { get; set; } 
        public string BusinessUnitXML { get; set; }
        public string MacAddress { get; set; }
        public Guid? EmployeeShiftId { get; set; }
        public bool IsEmployeeValid { get; set; }
        public bool IsUserValid { get; set; }
        public List<string> Messages { get; set;}
        public float Salary { get; set; }
        public Guid? PayrollTemplateId { get; set; }
        public Guid? UserAuthenticationId { get; set; }
        public bool? IsUpload { get; set; }
        public string IPNumber { get; set; }
        public Guid? DepartmentId { get; set; }
        public string FormSourc { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", Surname = " + SurName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", NationalityId = " + NationalityId);
            stringBuilder.Append(", DateOfJoining = " + DateOfJoining);
            stringBuilder.Append(", TaxCode = " + TaxCode);
            stringBuilder.Append(", DateOfBirth = " + DateOfBirth);
            stringBuilder.Append(", GenderId = " + GenderId);
            stringBuilder.Append(", MaritalStatusId = " + MaritalStatusId);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", RegisteredDateTime = " + RegisteredDateTime);
            stringBuilder.Append(", IsActiveOnMobile = " + IsActiveOnMobile);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            stringBuilder.Append(", Password = " + Password);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", EmployeeNumber = " + EmployeeNumber);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", JobCategoryId = " + JobCategoryId);
            stringBuilder.Append(", ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", IsUpsertEmployee = " + IsUpsertEmployee);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            stringBuilder.Append(", MarriageDate = " + MarriageDate);
            stringBuilder.Append(", MacAddress = " + MacAddress);
            stringBuilder.Append(", IPNumber = " + IPNumber);
            stringBuilder.Append(", EmployeeShiftId = " + EmployeeShiftId);
            stringBuilder.Append(", Salary = " + Salary);
            stringBuilder.Append(", PayrollTemplateId = " + PayrollTemplateId);
            stringBuilder.Append(", DepartmentId = " + DepartmentId);
            return stringBuilder.ToString();
        }
    }

}

