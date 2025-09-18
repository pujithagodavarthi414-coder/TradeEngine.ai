using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ComplianceAudit
{
    public class QuestionTypeApiInputModel : InputModelBase
    {
        public QuestionTypeApiInputModel() : base(InputTypeGuidConstants.BranchUpsertInputCommandTypeGuid)
        {
        }

        public Guid? QuestionTypeId { get; set; }
        public string QuestionTypeName { get; set; }
        public Guid? MasterQuestionTypeId { get; set; }
        public string QuestionTypeOptionsXml { get; set; }
        public string SearchText { get; set; }
        public bool IsArchived { get; set; }
        public bool? IsFromMasterQuestionType { get; set; }
        public List<QuestionTypeOptionsModel> QuestionTypeOptions { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("QuestionTypeId = " + QuestionTypeId);
            stringBuilder.Append(", QuestionTypeName = " + QuestionTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}