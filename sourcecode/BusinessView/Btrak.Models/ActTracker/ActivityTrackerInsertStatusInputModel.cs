using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;

namespace Btrak.Models.ActTracker
{
    public class ActivityTrackerInsertStatusInputModel : InputModelBase
    {
        public ActivityTrackerInsertStatusInputModel() : base(InputTypeGuidConstants.ActivityTrackerInsertStatusInputCommandTypeGuid)
        {

        }

        public List<string> MacAddress { get; set; }
        public string DeviceId { get; set; }
        public string MacAddressXml { get; set; }
        public DateTime Time { get; set; }
        public DateTime Date { get; set; }
        public string MobileVersionNumber { get; set; }
        public string WindowsVersionNumber { get; set; }

        public string LinuxVersionNumber { get; set; }

        public string OSName { get; set; }
        public string OSVersion { get; set; }
        public string Platform { get; set; }
        public string TimechampVersion { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", MacAddress" + MacAddress);
            stringBuilder.Append(", MacAddressXml" + MacAddressXml);
            stringBuilder.Append(", Time = " + Time);
            stringBuilder.Append(", Date = " + Date);
            return stringBuilder.ToString();
        }
    }
}
