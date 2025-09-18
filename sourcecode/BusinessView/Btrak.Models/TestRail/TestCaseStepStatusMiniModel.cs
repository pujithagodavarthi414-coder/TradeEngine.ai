using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestCaseStepStatusMiniModel
    {
        public Guid? Id { get; set; }

        public string ExpectedResult { get; set; }

        public string ActualResult { get; set; }

        public string StatusName { get; set; }

        public Guid? StatusId { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ExpectedResult = " + ExpectedResult);
            stringBuilder.Append(", ActualResult = " + ActualResult);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", StatusName = " + StatusName);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
