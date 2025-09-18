using BTrak.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Btrak.Models.ActivityTracker
{
    public class InsertUserActivityScreenShotInputModel : InputModelBase
    {
        public InsertUserActivityScreenShotInputModel() : base(InputTypeGuidConstants.InsertUserActivityScreenShotInputCommandTypeGuid)
        {

        }

        public Guid? Id { get; set; }
        public List<string> MACAddress { get; set; }
        public string DeviceId { get; set; }
        public string ScreenShotName { get; set; }
        public string ScreenShotUrl { get; set; }
        public string FileName { get; set; }
        public DateTimeOffset? ScreenShotDate { get; set; }
        public string ApplicationName { get; set; }
        public string Mac { get; set; }
        public double KeyStroke { get; set; }
        public double MouseMovements { get; set; }

        public byte[] FileStream { get; set; }

        public string FileType { get; set; }
        public string ActivityToken { get; set; }
        public string TimeZone { get; set; }
        public bool IsLiveScreenShot { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", MACAddress = " + MACAddress);
            stringBuilder.Append(", ScreenShotName = " + ScreenShotName);
            stringBuilder.Append(", ScreenShotUrl = " + ScreenShotUrl);
            stringBuilder.Append(", ScreenShotDate = " + ScreenShotDate);
            stringBuilder.Append(", ApplicationName = " + ApplicationName);
            stringBuilder.Append(", KeyStroke = " + KeyStroke);
            stringBuilder.Append(", MouseMovements = " + MouseMovements);
            return stringBuilder.ToString();
        }
    }
}
