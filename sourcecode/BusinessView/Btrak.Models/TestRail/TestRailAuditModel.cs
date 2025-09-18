using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRailAuditModel
    {
        public Guid Id { get; set; }

        public string AuditJson { get; set; }

        public Guid CompanyId { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public Guid CreatedByUserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", AuditJson = " + AuditJson);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            return stringBuilder.ToString();
        }
    }
}
