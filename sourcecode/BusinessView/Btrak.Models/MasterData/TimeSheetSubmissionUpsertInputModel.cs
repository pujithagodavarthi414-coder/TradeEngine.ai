using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class TimeSheetSubmissionUpsertInputModel :SearchCriteriaInputModelBase
    {
        public TimeSheetSubmissionUpsertInputModel() : base(InputTypeGuidConstants.TimeSheetSubmissionInputCommandTypeGuid)
        {
        }
        public Guid? TimeSheetSubmissionId { get; set; }
        public Guid? TimeSheetIntervalId { get; set; }
        public Guid? TimeSheetFrequencyId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
    }
}
