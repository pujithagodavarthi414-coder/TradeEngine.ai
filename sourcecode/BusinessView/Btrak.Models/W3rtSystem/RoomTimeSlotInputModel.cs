using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class RoomTimeSlotInputModel : SearchCriteriaInputModelBase
    {

        public RoomTimeSlotInputModel() : base(InputTypeGuidConstants.RoomTimeSlotInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? RoomId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append("RoomId = " + RoomId);
            return stringBuilder.ToString();
        }

    }
}