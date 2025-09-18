using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class EventOutputModel
    {
        public Guid? EventId { get; set; }
        public string EventName { get; set; }
        public string Description { get; set; }
        public Guid? VenueId { get; set; }
        public int TotalCount { get; set; }
    }
}
