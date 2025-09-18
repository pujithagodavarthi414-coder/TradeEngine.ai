using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerScreenshotFrequencySearchInputModel : SearchCriteriaInputModelBase
    {
        public ActTrackerScreenshotFrequencySearchInputModel() : base(InputTypeGuidConstants.ActTrackerScreenshotFrequencySearchInputCommandTypeGuid)
        {
        }

        public List<string> MACAddress { get; set; }
        public string DeviceId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MACAddress = " + MACAddress);
            stringBuilder.Append("DeviceId = " + DeviceId);
            return stringBuilder.ToString();
        }
    }
}
