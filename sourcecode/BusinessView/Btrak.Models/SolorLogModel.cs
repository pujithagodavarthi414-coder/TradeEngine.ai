using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class SolorLogModel
    {
        public Guid? SiteId { get; set; }
        public Guid? SolarId { get; set; }
        public string SiteName { get; set; }
        public DateTime Date { get; set; }
        public decimal? SolarLogValue { get; set; }
        public string SolarLogValueString { get; set; }
        public string SolarLogValueMutipleString { get; set; }
        public bool Confirm { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public string SearchText { get; set; }

    }
}
