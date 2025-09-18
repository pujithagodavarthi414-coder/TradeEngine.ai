

using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.W3rtSystem
{
    public class RoomsBasedOnSearchInputModel: SearchCriteriaInputModelBase
    {
        public RoomsBasedOnSearchInputModel() : base(InputTypeGuidConstants.RoomsBasedOnSearchInputModelCommandTypeGuid)
        {
        }

        public Guid? AmenityId { get; set; }
        public Guid? VenueId { get; set; }
        public string TownOrLocality { get; set; }
        public Guid? Event { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AmenityId = " + AmenityId);
            stringBuilder.Append("VenueId = " + VenueId);
            stringBuilder.Append("TownOrLocality = " + TownOrLocality);
            return stringBuilder.ToString();
        }
    }
}
