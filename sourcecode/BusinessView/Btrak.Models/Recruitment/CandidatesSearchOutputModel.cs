using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidatesSearchOutputModel
    {
        public Guid? CandidateId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FatherName { get; set; }
        public string Email { get; set; }
        public string CandidateUniqueName { get; set; }
        public string ProfileImage { get; set; }
        public string SecondaryEmail { get; set; }
        public string Mobile { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string Website { get; set; }
        public string SkypeId { get; set; }
        public string TwitterId { get; set; }
        public string AddressJson { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public int ExperienceInYears { get; set; }
        public Guid? CurrentDesignation { get; set; }
        public string CurrentDesignationName { get; set; }
        public string CurrentSalary { get; set; }
        public string ExpectedSalary { get; set; }
        public Guid? SourceId { get; set; }
        public string SourceName { get; set; }
        public Guid? SourcePersonId { get; set; }
        public string SourcePersonName { get; set; }
        public Guid? HiringStatusId { get; set; }
        public Guid? CandidateJobOpeningId { get; set; }
        public string HiringStatusName { get; set; }
        public string Color { get; set; }
        public Guid? AssignedToManagerId { get; set; }
        public string AssignedToManagerName { get; set; }
        public Guid? ClosedById { get; set; }
        public string ClosedByUserName { get; set; }
        public Guid? InterviewProcessId { get; set; }
        public string InterviewProcessName { get; set; }
        public string Description { get; set; }
        public string JobOpeningTitle { get; set; }
        public DateTime? AppliedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public bool? IsJobOpening { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? UserId { get; set; }
        public Guid? EmployeeId { get; set; }
        public string SurName { get; set; }
        public string InterviewTypeIds { get; set; }
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
        public string PermittedBranchIds { get; set; }
        public string BusinessUnitXML { get; set; }
        public string MacAddress { get; set; }
        public Guid? EmployeeShiftId { get; set; }
        public bool IsEmployeeValid { get; set; }
        public bool IsUserValid { get; set; }
        public float Salary { get; set; }
        public Guid? PayrollTemplateId { get; set; }
        public bool? IsUpload { get; set; }
        public string IPNumber { get; set; }
        public Guid? DepartmentId { get; set; }
        public string CountryCode { get; set; }
        public bool? IsEmployee { get; set; }
        public int TotalCount { get; set; }
        public int PageSize { get; set; }
        public int PageNumber { get; set; }

        //public override string ToString()
        //{
        //    StringBuilder stringBuilder = new StringBuilder();
        //    stringBuilder.Append(", CandidateId = " + CandidateId);
        //    stringBuilder.Append(", FirstName = " + FirstName);
        //    stringBuilder.Append(", LastName = " + LastName);
        //    stringBuilder.Append(", Email = " + Email);
        //    stringBuilder.Append(", SecondaryEmail = " + SecondaryEmail);
        //    stringBuilder.Append(", Mobile = " + Mobile);
        //    stringBuilder.Append(", Phone = " + Phone);
        //    stringBuilder.Append(", Fax = " + Fax);
        //    stringBuilder.Append(", Website = " + Website);
        //    stringBuilder.Append(", SkypeId = " + SkypeId);
        //    stringBuilder.Append(", TwitterId = " + TwitterId);
        //    stringBuilder.Append(", AddressJson = " + AddressJson);
        //    stringBuilder.Append(", CountryId = " + CountryId);
        //    stringBuilder.Append(", CountryName = " + CountryName);
        //    stringBuilder.Append(", ExperienceInYears = " + ExperienceInYears);
        //    stringBuilder.Append(", CurrentDesignation = " + CurrentDesignation);
        //    stringBuilder.Append(", CurrentSalary = " + CurrentSalary);
        //    stringBuilder.Append(", ExpectedSalary = " + ExpectedSalary);
        //    stringBuilder.Append(", SourceId = " + SourceId);
        //    stringBuilder.Append(", SourceName = " + SourceName);
        //    stringBuilder.Append(", SourcePersonId = " + SourcePersonId);
        //    stringBuilder.Append(", SourcePersonName = " + SourcePersonName);
        //    stringBuilder.Append(", HiringStatusId = " + HiringStatusId);
        //    stringBuilder.Append(", HiringStatusName = " + HiringStatusName);
        //    stringBuilder.Append(", AssignedToManagerId = " + AssignedToManagerId);
        //    stringBuilder.Append(", AssignedToManagerName = " + AssignedToManagerName);
        //    stringBuilder.Append(", ClosedById = " + ClosedById);
        //    stringBuilder.Append(", ClosedByUserName = " + ClosedByUserName);
        //    stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
        //    stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
        //    return stringBuilder.ToString();
        //}
    }
}
