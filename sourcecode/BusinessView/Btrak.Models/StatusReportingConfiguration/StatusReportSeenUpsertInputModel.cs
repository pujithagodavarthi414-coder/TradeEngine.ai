using System;
using System.Text;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportSeenUpsertInputModel
    {
        public Guid StatusReportId { get; set; }

        public bool SeenStatus { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StatusReportId = " + StatusReportId);
            stringBuilder.Append(", SeenStatus = " + SeenStatus);
            return stringBuilder.ToString();
        }
    }
}