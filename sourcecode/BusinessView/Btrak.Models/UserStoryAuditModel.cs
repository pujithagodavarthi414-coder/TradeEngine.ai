using System;

namespace Btrak.Models
{
    public class AuditModelFields
    {
        public Guid UserId { get; set; }
        public Guid FeatureId { get; set; }
        public Guid UserStoryId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}
