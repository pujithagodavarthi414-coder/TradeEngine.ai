using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Integration
{
    public class CompanyOrUserLevelIntegrationDetailsModel
    {
        public Guid? Id { get; set; }
        public Guid IntegrationTypeId { get; set; }
        public string IntegrationUrl { get; set; }
        public string UserName { get; set; }
        public string ApiToken { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public bool IsArchived { get; set; }
        public string IntegrationType { get; set; }
        public Guid? UserId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", IntegrationTypeId = " + IntegrationTypeId);
            stringBuilder.Append(", IntegrationUrl = " + IntegrationUrl);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", ApiToken = " + ApiToken);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IntegrationType = " + IntegrationType);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
