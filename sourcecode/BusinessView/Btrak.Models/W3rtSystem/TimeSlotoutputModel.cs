using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class TimeSlotOutputModel
    {
        public Guid? TimeSlotId { get; set; }
        public string TimeSlot { get; set; }
        public Guid? OrganisationId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
    }
    
}
