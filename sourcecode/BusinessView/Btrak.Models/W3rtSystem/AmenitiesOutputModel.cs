
using System;
using System.Text;


namespace Btrak.Models.W3rtSystem
{
    public class AmenitiesOutputModel
    {
  
        public Guid? AmenityId { get; set; }
        public string AmenityName { get; set; }
        public string Description { get; set; }
        public Guid RoomId { get; set; }
        public Guid VenueId { get; set; }
        public Guid RoomAmenityId { get; set; }
        public Guid VenueAmenityId { get; set; }
        public decimal Price { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AmenityId = " + AmenityId);
            stringBuilder.Append("AmenityName = " + AmenityName);
            stringBuilder.Append("Description = " + Description);
            stringBuilder.Append("RoomId = " + RoomId);
            stringBuilder.Append("VenueId = " + VenueId);
            stringBuilder.Append("RoomAmenityId = " + RoomAmenityId);
            stringBuilder.Append("VenueAmenityId = " + VenueAmenityId);
            stringBuilder.Append("Price = " + Price);
            return stringBuilder.ToString();
        }
    }
}
