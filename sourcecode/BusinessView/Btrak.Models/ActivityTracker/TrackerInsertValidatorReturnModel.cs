using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TrackerInsertValidatorReturnModel
    {
        public Guid UserId { get; set; }
        public Guid CompanyId { get; set; }
        public String ActivityToken { get; set; }
        public bool CanInsert { get; set; }
    }
}
