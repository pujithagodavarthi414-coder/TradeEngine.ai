using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestCaseAutomationTypeOutputModel
    {
        
        public Guid? Id { get; set; }
        public string AutomationTypeName { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public int? IsDefault { get; set;  }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", Value = " + AutomationTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsDefault = " + IsDefault);
            return stringBuilder.ToString();
        }
    }
}
