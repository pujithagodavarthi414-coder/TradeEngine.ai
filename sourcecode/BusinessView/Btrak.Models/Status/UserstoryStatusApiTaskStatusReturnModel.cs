using System;
using System.Text;

namespace Btrak.Models.Status
{
    public class UserstoryStatusApiTaskStatusReturnModel
    {
        public Guid? TaskStatusId { get; set; }
        public string TaskStatusName { get; set; }

        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TaskStatusId = " + TaskStatusId);
            stringBuilder.Append(", TaskStatusName = " + TaskStatusName);
            return stringBuilder.ToString();
        }
    }
}
