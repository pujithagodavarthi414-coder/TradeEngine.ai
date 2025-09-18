using BTrak.Common;
using System;
using System.Text;


namespace Btrak.Models.ComplianceAudit
{
    public class AuditCategoryApiInputModel : InputModelBase
    {
        public AuditCategoryApiInputModel() : base(InputTypeGuidConstants.AuditCategoryInputModelCommandTypeGuid)
        {
        }

        public Guid? AuditCategoryId { get; set; }
        public string AuditCategoryName { get; set; }
        public Guid? ParentAuditCategoryId { get; set; }
        public bool IsArchived { get; set; }
        public bool IsCategoriesRequired { get; set; }
        public Guid? AuditId { get; set; }
        public Guid? ConductId { get; set; }
        public string AuditCategoryDescription { get; set; }
        public string SearchText { get; set; }
        public Guid? AuditVersionId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AuditCategoryId = " + AuditCategoryId);
            stringBuilder.Append(", AuditCategoryName = " + AuditCategoryName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsCategoriesRequired = " + IsCategoriesRequired);
            stringBuilder.Append(", ParentAuditCategoryId = " + ParentAuditCategoryId);
            stringBuilder.Append(", AuditId = " + AuditId);
            stringBuilder.Append(", ConductId = " + ConductId);
            stringBuilder.Append(", AuditCategoryDescription = " + AuditCategoryDescription);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
