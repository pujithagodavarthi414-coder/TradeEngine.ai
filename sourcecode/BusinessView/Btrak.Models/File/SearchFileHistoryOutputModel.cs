using System;
using System.Text;

namespace Btrak.Models.File
{
    public class SearchFileHistoryOutputModel
    {
        public Guid? FileHistoryId { get; set; }
        public string FileName { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("  FileHistoryId = " + FileHistoryId);
            stringBuilder.Append(",  FileName = " + FileName);
            stringBuilder.Append(",  CompanyId = " + CompanyId);
            stringBuilder.Append(",  CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(",  CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(",  TotalCount = " + TotalCount);
            return base.ToString();
        }
    }
}