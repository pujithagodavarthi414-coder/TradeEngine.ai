using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models
{
    public class LoggedInContext
    {
        public Guid LoggedInUserId { get; set; }
        public int? TimeZoneOffset { get; set; }
        public Guid CompanyGuid { get; set; }
        public string RequestedHostAddress { get; set; }

        public string CurrentUrl { get; set; }
        public string Authorization { get; set; }
        public string TimeZoneString { get; set; }
        public string CompanyName { get; set; }
    }
}
