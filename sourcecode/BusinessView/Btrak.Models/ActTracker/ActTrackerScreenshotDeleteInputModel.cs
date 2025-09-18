using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerScreenshotDeleteInputModel : InputModelBase
    {
        public ActTrackerScreenshotDeleteInputModel() : base(InputTypeGuidConstants.ActTrackerScreenshotDeleteInputCommandTypeGuid)
        {
        }
        public List<Guid> ScreenshotId { get; set; }
        public string ScreenshotXml { get; set; }
        public string Reason { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ScreenshotId = " + ScreenshotId);
            stringBuilder.Append(", AppUrlTypeId = " + ScreenshotXml);
            stringBuilder.Append(", AppUrlName = " + Reason);
            return stringBuilder.ToString();
        }
    }
}
