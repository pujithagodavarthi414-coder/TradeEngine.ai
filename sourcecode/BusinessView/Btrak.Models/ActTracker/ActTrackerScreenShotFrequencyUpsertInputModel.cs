using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerScreenShotFrequencyUpsertInputModel : InputModelBase
    {
        public ActTrackerScreenShotFrequencyUpsertInputModel() : base(InputTypeGuidConstants.ActTrackerScreenshotFrequencyUpsertInputCommandTypeGuid)
        {
        }

        public List<Guid?> RoleIds { get; set; }
        public List<Guid?> UserIds { get; set; }
        public int? ScreenShotFrequency { get; set; }
        public int? Multiplier { get; set; }
        public string RoleIdXml { get; set; }
        public string UserIdXml { get; set; }
        public List<Guid?> ConfiguredRoleIds { get; set; }
        public int? FrequencyIndex { get; set; }
        public bool? Remove { get; set; }
        public bool SelectAll { get; set; }
        public bool IsUserSelectAll { get; set; }
        public bool IsRandomScreenshot { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RoleIds = " + RoleIds);
            stringBuilder.Append(", UserIds = " + UserIds);
            stringBuilder.Append(", ScreenShotFrequency = " + ScreenShotFrequency);
            stringBuilder.Append(", Multiplier = " + Multiplier);
            stringBuilder.Append(", RoleIdXml = " + RoleIdXml);
            stringBuilder.Append(", UserIdXml = " + UserIdXml);
            stringBuilder.Append(", ConfiguredRoleIds = " + ConfiguredRoleIds);
            stringBuilder.Append(", FrequencyIndex = " + FrequencyIndex);
            stringBuilder.Append(", Remove = " + Remove);
            stringBuilder.Append(", SelectAll = " + SelectAll);
            stringBuilder.Append(", IsUserSelectAll = " + IsUserSelectAll);
            stringBuilder.Append(", IsRandomScreenshot =  " + IsRandomScreenshot);
            return stringBuilder.ToString();
        }
    }
}
