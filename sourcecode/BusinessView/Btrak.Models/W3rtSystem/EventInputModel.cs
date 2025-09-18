using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class EventInputModel : SearchCriteriaInputModelBase
    {
        public EventInputModel() : base(InputTypeGuidConstants.EventInputModelCommandTypeGuid)
        {
        }

        public Guid? EventId { get; set; }
        public string Description { get; set; }
        public string EventName { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EventId = " + EventId);
            return stringBuilder.ToString();
        }
    }
}
