using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Site
{
    public class GridForSiteProjectionModel
    {
        public Guid? GridForSiteProjectionId { get; set; }
        public Guid? SiteId { get; set; }
        public Guid? GridId { get; set; }
        public string SiteName { get; set; }
        public string GridName { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool? IsArchived { get; set; }
    }
}
