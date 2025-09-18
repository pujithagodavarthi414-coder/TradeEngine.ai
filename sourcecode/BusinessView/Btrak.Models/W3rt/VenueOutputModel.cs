using System;
using System.Text;

namespace Btrak.Models.W3rt
{
    public class VenueOutputModel
    {
        public Guid Id { get; set; }
        public Guid OrganisationId { get; set; }
        public string VenueName { get; set; }
        public string ImageJson { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public string Description { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id" + Id);
            stringBuilder.Append("OrganisationId" + OrganisationId);
            stringBuilder.Append("VenueName" + VenueName); 
            stringBuilder.Append("ImageJson" + ImageJson);
            stringBuilder.Append("CreatedDateTime" + CreatedDateTime);
            stringBuilder.Append("CreatedByUserId" + CreatedByUserId);
            stringBuilder.Append("UpdatedDateTime" + UpdatedDateTime);
            stringBuilder.Append("UpdatedByUserId" + UpdatedByUserId);
            stringBuilder.Append("Description" + Description);
            return base.ToString();
        }
    }
}
