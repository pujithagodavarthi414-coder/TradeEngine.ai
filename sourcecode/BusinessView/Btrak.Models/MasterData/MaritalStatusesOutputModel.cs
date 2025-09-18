using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class MaritalStatusesOutputModel
    {
        public Guid? MaritalStatusId { get; set; }
        public string MaritalStatus { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" MaritalStatusId = " + MaritalStatusId);
            stringBuilder.Append(", MaritalStatus = " + MaritalStatus);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
