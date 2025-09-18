using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.CustomApplication
{
    public class FormHistoryModel : SearchCriteriaInputModelBase
    {
        public FormHistoryModel() : base(InputTypeGuidConstants.FormHistoryModel)
        {
        }

        public Guid? FormHistoryId { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
        public string FormName { get; set; }
        public string FormJson { get; set; }
        public string FieldName { get; set; }
        public string OldFieldValue { get; set; }
        public string NewFieldValue { get; set; }
        public string CreatedBy { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedDate { get; set; }
        public string CreatedProfileImage { get; set; }
        public int TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FormHistoryId = " + FormHistoryId);
            stringBuilder.Append(", GenericFormSubmittedId = " + GenericFormSubmittedId);
            stringBuilder.Append(", CreatedBy = " + CreatedBy);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedProfileImage = " + CreatedProfileImage);
            stringBuilder.Append(", FormName = " + FormName);
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", FieldName = " + FieldName);
            stringBuilder.Append(", OldFieldValue = " + OldFieldValue);
            stringBuilder.Append(", NewFieldValue = " + NewFieldValue);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
