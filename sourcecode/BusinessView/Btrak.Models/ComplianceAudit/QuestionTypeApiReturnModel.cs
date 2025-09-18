using System;
using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ComplianceAudit
{
    public class QuestionTypeApiReturnModel : InputModelBase
    {
        public QuestionTypeApiReturnModel() : base(InputTypeGuidConstants.BranchUpsertInputCommandTypeGuid)
        {
        }

        public Guid? QuestionTypeId { get; set; }
        public string QuestionTypeName { get; set; }
        public bool IsArchived { get; set; }
        public bool CanQuestionTypeDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? MasterQuestionTypeId { get; set; }
        public string MasterQuestionTypeName { get; set; }
        public string QuestionTypeOptionName { get; set; }
        public string QuestionTypeOptionsXml { get; set; }
        public List<QuestionTypeOptionsModel> QuestionTypeOptions { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("QuestionTypeId = " + QuestionTypeId);
            stringBuilder.Append(", QuestionTypeName = " + QuestionTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CanQuestionTypeDeleted = " + CanQuestionTypeDeleted);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}