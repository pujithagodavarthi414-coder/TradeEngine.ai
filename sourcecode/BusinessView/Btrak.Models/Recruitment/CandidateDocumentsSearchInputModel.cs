using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidateDocumentsSearchInputModel : SearchCriteriaInputModelBase
    {
        public CandidateDocumentsSearchInputModel() : base(InputTypeGuidConstants.CandidateDocumentsSearchInputCommandTypeGuid)
        {
        }
       
        public Guid? CandidateDocumentsId { get; set; }
        public Guid? CandidateId { get; set; }
        public Guid? DocumentTypeId { get; set; }
        public string Document { get; set; }
        public bool? IsResume { get; set; }
        public string Description { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateDocumentsId = " + CandidateDocumentsId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(", DocumentTypeId = " + DocumentTypeId);
            stringBuilder.Append(", Document = " + Document);
            stringBuilder.Append(", IsResume = " + IsResume);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
