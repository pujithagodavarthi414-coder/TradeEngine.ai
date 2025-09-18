using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BTrak.Common
{
    public class MSMQPathConstants
    {
        public const string TrackerActivityPublishPath = "FormatName:DIRECT=OS:.\\private$\\tracker_activity";
        public const string TrackerActivityListenerPath = ".\\private$\\tracker_activity";

        public const string TrackerScreenshotPublishPath = "FormatName:DIRECT=OS:.\\private$\\tracker_screenshot";
        public const string TrackerScreenshotListenerPath = ".\\private$\\tracker_screenshot";

        public const string TrackerSummaryPublishPath = "FormatName:DIRECT=OS:.\\private$\\tracker_summary";
        public const string TrackerSummaryListenerPath = ".\\private$\\tracker_summary";
    }
}
