using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class DocumentTypeUpsertInputModel : SearchCriteriaInputModelBase
    {
        public DocumentTypeUpsertInputModel() : base(InputTypeGuidConstants.DocumentTypeUpsertInputCommandTypeGuid)
        {
        }
  
        public Guid? DocumentTypeId { get; set; }
        public string DocumentTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateDocumentsId = " + DocumentTypeId);
            stringBuilder.Append(",CandidateId = " + DocumentTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
