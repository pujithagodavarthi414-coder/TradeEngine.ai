using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Audit
{
    public class AuditSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public AuditSearchCriteriaInputModel() : base(InputTypeGuidConstants.AuditSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? UserId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? FeatureId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", FeatureId = " + FeatureId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }
    }
}
