using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class CustomFormSubmissionUpsertModel : InputModelBase
    {

        public CustomFormSubmissionUpsertModel() : base(InputTypeGuidConstants.CustomFormSubmissionInputCommandTypeGuid)
        {
        }
        public Guid? FormSubmissionId { get; set; }
        public Guid? GenericFormId { get; set; }
        public string FormData { get; set; }
        public string Status { get; set; }
        public Guid? AssignedToUserId { get; set; }
        public Guid? AssignedByUserId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FormSubmissionId= " + FormSubmissionId);
            stringBuilder.Append(", GenericFormId= " + GenericFormId);
            stringBuilder.Append(", Status= " + Status);
            stringBuilder.Append(", AssignedToUserId= " + AssignedToUserId);
            stringBuilder.Append(", AssignedByUserId= " + AssignedByUserId);
            stringBuilder.Append(", IsArchived= " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
