using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class RoomConfigurationSearchInputModel : SearchCriteriaInputModelBase
    {
        public RoomConfigurationSearchInputModel() : base(InputTypeGuidConstants.RoomConfigurationSearchInputCommandTypeGuid)
        {
        }

        public Guid? RoomId { get; set; }
        public List<Guid> OrganisationId { get; set; }
        public List<Guid> VenueId { get; set; }
        public string OrganisationIdXml { get; set; }
        public string VenueIdXml { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RoomId = " + RoomId);
            stringBuilder.Append(", VenueId = " + VenueId);
            stringBuilder.Append(", OrganisationId = " + VenueId);
            return stringBuilder.ToString();
        }
    }
}
