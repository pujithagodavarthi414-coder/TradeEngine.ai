using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.W3rtSystem
{
    public class RoomAndVenuAmenitiesInputModel: SearchCriteriaInputModelBase
    {
        public RoomAndVenuAmenitiesInputModel() : base(InputTypeGuidConstants.RoomAndVenuAmenitiesInputModelCommandTypeGuid)
        {
        }

        public Guid? AmenityId { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AmenityId = " + AmenityId);
            return stringBuilder.ToString();
        }
    }
}
