using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class CandidateDocumentUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CandidateDocumentUpsertInputModel() : base(InputTypeGuidConstants.CandidateDocumentsUpsertInputCommandTypeGuid)
        {
        }

        public Guid? CandidateDocumentsId { get; set; }
        public Guid? CandidateId { get; set; }
        public Guid? DocumentTypeId { get; set; }
        public string Document { get; set; }
        public string Description { get; set; }
        public bool? IsResume { get; set; }
        public List<Guid?> CandidateDocumentsIdList { get; set; }
        public List<string> DocumentArray { get; set; }
        public string DocumentName { get; set; }
        public string CandidateName { get; set; }
        public string CandidateEmail { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateDocumentsId = " + CandidateDocumentsId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(", DocumentTypeId = " + DocumentTypeId);
            stringBuilder.Append(", IsResume = " + IsResume);
            stringBuilder.Append(", Document = " + Document);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
