using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestSuiteDownloadModel : InputModelBase
    {
        public TestSuiteDownloadModel() : base(InputTypeGuidConstants.TestSuiteInputCommandTypeGuid)
        {
        }

        public string ProjectName { get; set; }

        public string Download { get; set; }

        public string TestSuiteName { get; set; }

        public string PersonName { get; set; }

        public string ToMails { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ProjectName = " + ProjectName);
            stringBuilder.Append(", Download = " + Download);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", PersonName = " + PersonName);
            stringBuilder.Append(", ToMails = " + ToMails);
            
            return stringBuilder.ToString();
        }
    }
}
