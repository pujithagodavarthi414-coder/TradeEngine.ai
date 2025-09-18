using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class RoomSearchInputModel
    {
        public List<Guid> OrganisationId { get; set; }

        public Guid? EventId { get; set; }

        public List<Guid> VenueId { get; set; }
        
        public string VenueIdXml { get; set; }

        public DateTime? FromDate { get; set; }

        public DateTime? ToDate { get; set; }

        public string FromTime { get; set; }

        public string ToTime { get; set; }

        public string DayType { get; set; }

        public int PageNo { get; set; }

        public string SearchText { get; set; }
    }
}
