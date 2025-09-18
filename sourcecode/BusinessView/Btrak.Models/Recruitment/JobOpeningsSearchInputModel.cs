using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class JobOpeningsSearchInputModel : SearchCriteriaInputModelBase
    {
        public JobOpeningsSearchInputModel() : base(InputTypeGuidConstants.JobOpeningsSearchInputCommandTypeGuid)
        {
        }

        public Guid? JobOpeningId { get; set; }
        public string JobOpeningTitle { get; set; }
        public string JobDescription { get; set; }
        public int NoOfOpenings { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public float MinExperience { get; set; }
        public float MaxExperience { get; set; }
        public string Qualification { get; set; }
        public string Email { get; set; }
        public string Certification { get; set; }
        public float MinSalary { get; set; }
        public float MaxSalary { get; set; }
        public Guid? JobTypeId { get; set; }
        public Guid? JobOpeningStatusId { get; set; }
        public Guid? InterviewProcessId { get; set; }
        public Guid? DesignationId { get; set; }
        public Guid? HiringManagerId { get; set; }
        public Guid? CandidateId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("JobOpeningId = " + JobOpeningId);
            stringBuilder.Append(",JobOpeningTitle = " + JobOpeningTitle);
            stringBuilder.Append(",JobDescription = " + JobDescription);
            stringBuilder.Append(",NoOfOpenings = " + NoOfOpenings);
            stringBuilder.Append(",DateFrom = " + DateFrom);
            stringBuilder.Append(",DateTo = " + DateTo);
            stringBuilder.Append(",Email = " + Email);
            stringBuilder.Append(",MinExperience = " + MinExperience);
            stringBuilder.Append(",MaxExperience = " + MaxExperience);
            stringBuilder.Append(",Qualification = " + Qualification);
            stringBuilder.Append(",Certification = " + Certification);
            stringBuilder.Append(",MinSalary = " + MinSalary);
            stringBuilder.Append(",MaxSalary = " + MaxSalary);
            stringBuilder.Append(",JobTypeId = " + JobTypeId);
            stringBuilder.Append(",JobOpeningStatusId = " + JobOpeningStatusId);
            stringBuilder.Append(",InterviewProcessId = " + InterviewProcessId);
            stringBuilder.Append(",DesignationId = " + DesignationId);
            stringBuilder.Append(",HiringManagerId = " + HiringManagerId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }

    }
}
