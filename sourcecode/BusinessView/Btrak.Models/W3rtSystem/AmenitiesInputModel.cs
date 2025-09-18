using BTrak.Common;
using System;
using System.Text;


namespace Btrak.Models.W3rtSystem
{
    public class AmenitiesInputModel: SearchCriteriaInputModelBase
    {
        public AmenitiesInputModel() : base(InputTypeGuidConstants.AmenityInputModelCommandTypeGuid)
        {
        }

        public Guid? AmenityId { get; set; }
        public Guid? RoomAmenityId { get; set; }
        public Guid? VenueAmenityId { get; set; }
        public Guid? RoomId { get; set; }
        public Guid? VenueId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AmenityId = " + AmenityId);
            stringBuilder.Append("RoomAmenityId = " + RoomAmenityId);
            stringBuilder.Append("VenueAmenityId = " + VenueAmenityId);
            stringBuilder.Append("RoomId = " + RoomId);
            stringBuilder.Append("VenueId = " + VenueId);
            return stringBuilder.ToString();
        }
    }
}
