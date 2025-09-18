using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseAssignInputModel : InputModelBase
    {
        public TestCaseAssignInputModel() : base(InputTypeGuidConstants.TestCaseAssignInputCommandTypeGuid)
        {
        }
        public Guid ProjectId { get; set; }

        public Guid? TestRunId { get; set; }

        public List<Guid?> TestCaseIds { get; set; }

        public string AssignToName { get; set; }

        public Guid? StatusId { get; set; }

        public string StatusComment { get; set; }

        public Guid? AssignToId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", TestRunId = " + TestRunId);
            stringBuilder.Append(", TestCaseIds = " + TestCaseIds);
            stringBuilder.Append(", AssignToName = " + AssignToName);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", StatusComment = " + StatusComment);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
