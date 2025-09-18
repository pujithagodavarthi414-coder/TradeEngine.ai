using System;
using System.Text;

namespace Btrak.Models.ButtonType
{
    public class ButtonTypeOutputModel
    {
        public Guid? ButtonTypeId { get; set; }
        public string ButtonTypeName { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpDatedDatetime { get; set; }
        public byte[] TimeStamp { get; set; }
        public string ButtonCode { get; set; }
        public string ShortName { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ButtonTypeId = " + ButtonTypeId);
            stringBuilder.Append(", ButtonTypeName = " + ButtonTypeName);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpDatedDatetime = " + UpDatedDatetime);
            stringBuilder.Append(", ButtonCode = " + ButtonCode);
            stringBuilder.Append(", ShortName = " + ShortName);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}