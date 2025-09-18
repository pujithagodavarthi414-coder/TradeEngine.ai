using System;
using System.Text;

namespace Btrak.Models.SoftLabels
{
    public class SoftLabelsOutputMethod
    {
        public Guid? SoftLabelId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public string SoftlabelName { get; set; }
        public string SoftlabelKeyType { get; set; }
        public string SoftlabelValue { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
       
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" SoftLabelId = " + SoftLabelId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", BranchName = " + BranchName); 
            stringBuilder.Append(", SoftlabelName = " + SoftlabelName);
            stringBuilder.Append(", SoftlabelKeyType = " + CompanyId);
            stringBuilder.Append(", SoftlabelValue = " + SoftlabelValue);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
