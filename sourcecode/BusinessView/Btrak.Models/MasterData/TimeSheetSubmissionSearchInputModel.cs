using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class TimeSheetSubmissionSearchInputModel
    {
        public Guid? TimeSheetSubmissionId { get; set; }
        public Guid? TimeSheetFrequencyId { get; set; }
        public bool? IsIncludedPastData { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? StatusId { get; set; }
    }
}
