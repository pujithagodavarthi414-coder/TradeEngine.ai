using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class DocumentTypesSearchInputModel : SearchCriteriaInputModelBase
    {
        public DocumentTypesSearchInputModel() : base(InputTypeGuidConstants.DocumentTypesSearchInputCommandTypeGuid)
        {
        }

        public Guid? DocumentTypeId { get; set; }
        public string DocumentTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateDocumentsId = " + DocumentTypeId);
            stringBuilder.Append(",CandidateId = " + DocumentTypeName);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
