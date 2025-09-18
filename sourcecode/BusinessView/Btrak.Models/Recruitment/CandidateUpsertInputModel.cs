using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class CandidateUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CandidateUpsertInputModel() : base(InputTypeGuidConstants.CandidateUpsertInputCommandTypeGuid)
        {
        }

        public Guid? CandidateId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FatherName { get; set; }
        public string Email { get; set; }
        public string Profile { get; set; }
        public string SecondaryEmail { get; set; }
        public string Mobile { get; set; }
        public string Phone { get; set; }
        public string AddressJson { get; set; }
        public string CurrentSalary { get; set; }
        public string ExpectedSalary { get; set; }
        public int ExperienceInYears { get; set; }
        public string SkypeId { get; set; }
        public Guid? AssignedToManagerId { get; set; }
        public Guid? HiringStatusId { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? CurrentDesignation { get; set; }
        public Guid? SourceId { get; set; }
        public Guid? SourcePersonId { get; set; }
        public string Fax { get; set; }
        public string Website { get; set; }
        public string TwitterId { get; set; }
        public string Description { get; set; }
        public Guid? ClosedById { get; set; }
        public Guid? JobOpeningId { get; set; }
        public Guid? CandidateJobOpeningId { get; set; }
        public bool? IsJobLink { get; set; }
        public bool? IsJob { get; set; }
        public string CandidateJson { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateId = " + CandidateId);
            stringBuilder.Append(",FirstName = " + FirstName);
            stringBuilder.Append(", LastName = " + LastName);
            stringBuilder.Append(",Email = " + Email);
            stringBuilder.Append("SecondaryEmail = " + SecondaryEmail);
            stringBuilder.Append(",Mobile = " + Mobile);
            stringBuilder.Append(",Phone = " + Phone);
            stringBuilder.Append(", AddressJson = " + AddressJson);
            stringBuilder.Append(",CurrentSalary = " + CurrentSalary);
            stringBuilder.Append("ExpectedSalary = " + ExpectedSalary);
            stringBuilder.Append(",ExperienceInYears = " + ExperienceInYears);
            stringBuilder.Append(", SkypeId = " + SkypeId);
            stringBuilder.Append(",AssignedToManagerId = " + AssignedToManagerId);
            stringBuilder.Append(",HiringStatusId = " + HiringStatusId);
            stringBuilder.Append(",CountryId = " + CountryId);
            stringBuilder.Append(",CurrentDesignation = " + CurrentDesignation);
            stringBuilder.Append(",SourceId = " + SourceId);
            stringBuilder.Append(",SourcePersonId = " + SourcePersonId);
            stringBuilder.Append(",Fax = " + Fax);
            stringBuilder.Append(",Website = " + Website);
            stringBuilder.Append(",TwitterId = " + TwitterId);
            stringBuilder.Append(",Description = " + Description);
            stringBuilder.Append(",ClosedById = " + ClosedById);
            stringBuilder.Append(",JobOpeningId = " + JobOpeningId);
            stringBuilder.Append(",CandidateJobOpeningId = " + CandidateJobOpeningId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }

    }
}
