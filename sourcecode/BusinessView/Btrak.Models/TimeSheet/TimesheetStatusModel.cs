using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TimeSheet
{
    public class TimesheetStatusModel : InputModelBase
    {
        public TimesheetStatusModel() : base(InputTypeGuidConstants.TimeSheetStatusGuid)
        {
        }
        public Guid? StatusId { get; set; }
        public string StatusName { get; set; }
        public string StatusColour { get; set; }
    }
}
