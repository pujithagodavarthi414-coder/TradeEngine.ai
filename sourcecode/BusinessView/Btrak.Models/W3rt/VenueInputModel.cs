using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.W3rt
{
    public class VenueInputModel: SearchCriteriaInputModelBase
    {
        public VenueInputModel() : base(InputTypeGuidConstants.VenueInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? OrganisationId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id" + Id);
            stringBuilder.Append("OrganisationId" + OrganisationId);
            return base.ToString();
        }

    }
}
