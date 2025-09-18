using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestRailConfigurationInputModel
    {
        public Guid? TestRailConfigurationId { get; set; }
        public string ConfigurationName { get; set; }
        public float? ConfigurationTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestRailConfigurationId = " + TestRailConfigurationId);
            stringBuilder.Append(", ConfigurationName = " + ConfigurationName);
            stringBuilder.Append(", ConfigurationTime = " + ConfigurationTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
