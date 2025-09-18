using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidatesSearchInputModel : SearchCriteriaInputModelBase
    {
        public CandidatesSearchInputModel() : base(InputTypeGuidConstants.CandidateSearchInputCommandTypeGuid)
        {
        }

        public Guid? CandidateId { get; set; }
        public Guid? SkillId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FatherName { get; set; }
        public string Email { get; set; }
        public string SecondaryEmail { get; set; }
        public string Mobile { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string Website { get; set; }
        public string SkypeId { get; set; }
        public string TwitterId { get; set; }
        public string AddressJson { get; set; }
        public Guid? CountryId { get; set; }
        public int ExperienceInYears { get; set; }
        public Guid? CurrentDesignation { get; set; }
        public string CurrentSalary { get; set; }
        public string ExpectedSalary { get; set; }
        public Guid? SourceId { get; set; }
        public Guid? SourcePersonId { get; set; }
        public Guid? HiringStatusId { get; set; }
        public Guid? AssignedToManagerId { get; set; }
        public Guid? ClosedById { get; set; }
        public Guid? CanJobById { get; set; }
        public Guid? InterviewerId { get; set; }
        public string filedata { get; set; }
        public string package { get; set; }
        public DateTime offeredDate { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateId = " + CandidateId);
            stringBuilder.Append("FirstName = " + FirstName);
            stringBuilder.Append("LastName = " + LastName);
            stringBuilder.Append("FatherName = " + FatherName);
            stringBuilder.Append("Email = " + Email);
            stringBuilder.Append("Mobile = " + Mobile);
            stringBuilder.Append("Phone = " + Phone);
            stringBuilder.Append("Fax = " + Fax);
            stringBuilder.Append("Website = " + Website);
            stringBuilder.Append("SkypeId = " + SkypeId);
            stringBuilder.Append("TwitterId = " + TwitterId);
            stringBuilder.Append("AddressJson = " + AddressJson);
            stringBuilder.Append("CountryId = " + CountryId);
            stringBuilder.Append("ExperienceInYears = " + ExperienceInYears);
            stringBuilder.Append("CurrentDesignation = " + CurrentDesignation);
            stringBuilder.Append(",CurrentSalary = " + CurrentSalary);
            stringBuilder.Append(",ExpectedSalary = " + ExpectedSalary);
            stringBuilder.Append(",SourceId = " + SourceId);
            stringBuilder.Append(",SourcePersonId = " + SourcePersonId);
            stringBuilder.Append(",HiringStatusId = " + HiringStatusId);
            stringBuilder.Append(",AssignedToManagerId = " + AssignedToManagerId);
            stringBuilder.Append(",ClosedById = " + ClosedById);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }

    }
}
