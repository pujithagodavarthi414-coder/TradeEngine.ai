using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class TimeSlotInputModel : SearchCriteriaInputModelBase
    {
        public TimeSlotInputModel() : base(InputTypeGuidConstants.TimeSlotInputCommandTypeGuid)
        {
        }
        public Guid? TimeSlotId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TimeSlotId = " + TimeSlotId);
            return stringBuilder.ToString();
        }



    }
}
