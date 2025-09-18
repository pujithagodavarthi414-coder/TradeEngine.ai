

using System;
using System.Text;

namespace Btrak.Models.W3rtSystem
{
    public class RoomAndVenuAmenitiesOutputModel
    {
        public Guid? AmenityId { get; set; }
        public string AmenityName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AmenityId = " + AmenityId);
            stringBuilder.Append("AmenityName = " + AmenityName);

            return stringBuilder.ToString();
        }
    }
}
