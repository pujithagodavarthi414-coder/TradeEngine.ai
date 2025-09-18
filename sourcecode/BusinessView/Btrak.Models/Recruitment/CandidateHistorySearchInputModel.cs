using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidateHistorySearchInputModel : SearchCriteriaInputModelBase
    {
        public CandidateHistorySearchInputModel() : base(InputTypeGuidConstants.CandidateHistorySearchInputCommandTypeGuid)
        {
        }

        public Guid? CandidateHistoryId { get; set; }
        public Guid? CandidateId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string FieldName { get; set; }
        public string Description { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateHistoryId = " + CandidateHistoryId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(", JobOpeningId = " + JobOpeningId);
            stringBuilder.Append(", OldValue = " + OldValue);
            stringBuilder.Append(", NewValue = " + NewValue);
            stringBuilder.Append(", FieldName = " + FieldName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
